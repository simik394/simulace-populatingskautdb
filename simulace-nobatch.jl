using Distributions
using StatsBase  # Import for Weights function
using LoggingExtras

# Setup logger to save logs to a file
file_logger = FileLogger("simulation.log")
Logging.global_logger(file_logger)

# Simulation parameters

const NUM_AGENTS = 3  # Number of agents participating in the simulation
# const BATCH_UPLOAD_SIZES = [0, 10, 20, 30, 50, 100]  # Different initial batch upload sizes to test
const BATCH_UPLOAD_SIZES = [0, 10]
const initialQualityDist = LogNormal(3, 2)  # Distribution for the initial quality of records
const qualityImprovementProb = 0.7  # Probability of improving the quality of a record
const recordCreationProb = 0.3  # Probability of creating a new record when not searching

# Originaly I intended to have categories explicitly named for closer resemblance with reality
# but I failed to find a real contribution for the simulation, because real live categories are much more complex
# so this simplified idea is not much realistic to begin with
# therefore i came to conclusion that using just simple intagers to represent the categories will be better choice for this case.
#
# const TYPES = ["running", "creative", "thinking", "discussion", "history"]  # Types of activities
# const PLACES = ["room", "forest", "city", "playground"]  # Possible places for activities
# const CATEGORIES = [(t, p) for t in TYPES for p in PLACES]  # Generate all combinations of types and places
const categories = [1:20;] # Create representation of categories  # well ...
const targetSuccessfulness = 0.75
const nSuccessfullFromEpisode = 4
const episodeLength = 6

# Structs for records and agents
mutable struct Record
    id::Int
    # category::Int64  # Category of the record (type, place)
    quality::Float64  # Quality of the record
end

mutable struct Agent
    past_success_rate::Float64  # Success rate based on past database interaction
    used::Dict{Int,Vector{Int}}
end

# Initialize database, agents, and records
db = Dict{Int64,Vector{Record}}()  # Database storing records by category
for category in categories
    db[category] = Vector{Record}()  # Initialize an empty vector for each category
end

agents = [Agent(0.4, Dict()) for _ in 1:NUM_AGENTS]  # Initialize agents with a default success rate of 0.5
@info "Agents created: $agents"




# Helper functions
function search_database(agent::Agent, category::Int64, db::Dict)
    @info "Agent attempting to search database for category: $category"
    records = db[category]  # Retrieve records for the selected category
    if isempty(records)
        @warn "No records found in category: $category"
        return false, []  # Return failure if no records are found
    end

    # Calculate probabilities based on record quality
    probabilities = [rec.quality / sum(r.quality for r in records) for rec in records]
    selected_record = records[sample(1:length(records), Weights(probabilities))]  # Select a record probabilistically
    nToSample = length(records) > 8 ? 8 : length(records)
    selectedRecords = sample(records, Weights(probabilities), nToSample, replace=false)
    return true, selectedRecords

end

recordscreated = 0
function create_record()
    quality = rand(initialQualityDist)  # Generate initial quality from the distribution
    global recordscreated += 1
    @info "Creating new record with initial quality: $quality and id: $recordscreated"
    return Record(recordscreated, quality)  # Return a new record
end

function chanceToImproveRecord!(record::Record)
    if rand() < qualityImprovementProb
        @info "Agent improves the quality of the record."
        record.quality += rand(1.0:0.1:2.0)  # Improve record quality by a random amount
    end
end
function chanceToCreateRecord!(category::Int)
    if rand() < recordCreationProb
        @info "Agent creates a new record instead."
        push!(db[category], create_record())  # Create a new record instead of searching
        @info "Creating new record in category: $category"
    else
        @info "Agent had to prepare activity anyways, but it did not create a record of it in the db."
    end

end

function agentDecides(agent::Agent, week::Int, attempts, successes)
    category = categories[rand(1:length(categories))]  # Randomly select a category for the agent
    @info "Agent selects category: $category"

    # Decide whether to search or create a record
    if rand() < agent.past_success_rate

        @info "Agent decides to search the database."
        success, sRecords = search_database(agent, category, db)
        @debug "sRecords = $sRecords"
        attempts += 1

        if success
            for record in sRecords
                try
                    m = isempty(agent.used[record.id])
                    @debug "is empty $m"
                catch
                    agent.used[record.id] = Vector{Int}()
                    @debug "record not used yet"
                end

                recordUsage = agent.used[record.id]
                if !isempty(recordUsage) && week - last(recordUsage) > 54
                    durationFromLastUse = week - last(recordUsage)

                    push!(recordUsage, week)
                    chanceToImproveRecord!(record)
                    @info "Agent used found record: $record in week: $week"
                    @debug "Week from last use: $durationFromLastUse"
                    successes += 1
                    break

                elseif !isempty(recordUsage) && week - last(recordUsage) < 54
                    @info "Record used too recently. Its on cooldown. :)"
                    chanceToCreateRecord!(category)

                elseif isempty(recordUsage)
                    push!(recordUsage, week)
                    chanceToImproveRecord!(record)
                    @info "Agent used found record: $record in week: $week"
                    successes += 1
                    break
                end
            end

        else
            chanceToCreateRecord!(category)
            @info "Search failed. Chance for creating a new record."
        end
    else
        chanceToCreateRecord!(category)
        @info "Agent decides not to search the database."
    end
    return attempts, successes

end

function isUsefull(weeklySuccessRates::Vector{})
    failed = true
    try
        s = weeklySuccessRates
        p = s[length(s)-episodeLength:length(s)]
        p2 = s[length(s)-(2*episodeLength)-1:length(s)-episodeLength-1]
        p3 = s[length(s)-(3*episodeLength)-2:length(s)-(2*episodeLength)-2]
        past3months = [p, p2, p3]
        usefulInMonths = []
        for m in past3months
            moreSuccessfulThanSR = []
            for s in m
                if s > targetSuccessfulness
                    push!(moreSuccessfulThanSR, 1)
                else
                    push!(moreSuccessfulThanSR, 0)
                end

            end
            monthFailed = sum(moreSuccessfulThanSR) >= nSuccessfullFromEpisode ? false : true
            push!(usefulInMonths, monthFailed ? 0 : 1)
        end
        failed = 0 in usefulInMonths
    catch
        @info "Not enough values to determine usefulness."
    end

    return !failed
end
week = 0
function run_simulation(batch_upload_size)
    @info "Starting simulation with batch upload size: $batch_upload_size"
    # Initialize database with batch upload
    for _ in 1:batch_upload_size
        category = categories[rand(1:length(categories))]  # Randomly select a category
        record = create_record()
        push!(db[category], record)  # Add the record to the database
    end
    global recordscreated = 0
    weekly_success_rates = []  # Store success rates for each week
    isUseful = false
    global week = 0
    while !isUseful
        # println(recordscreated)
        global week += 1
        @info "Week $week simulation starts"
        successes = 0  # Count successful searches
        attempts = 0  # Count total search attempts

        for agent in agents
            attempts, successes = agentDecides(agent, week, attempts, successes)
            @debug "Attempts of agent $agent :$attempts . Successes: $successes"
        end
        @debug "Attempts/week: $attempts Successes/week $successes"
        success_rate = successes / max(attempts, 1)  # Calculate success rate for the week
        @info "Week $week success rate: $success_rate"
        push!(weekly_success_rates, success_rate)
        isUseful = isUsefull(weekly_success_rates)
    end
    @info "Simulation completed for batch upload size: $batch_upload_size"
    return weekly_success_rates  # Return success rates for all weeks
end
using Plots

# Run simulation for different batch upload sizes
results = Dict()
function runSimForBSizes()
    lastedFor = []
    nRecords = []
    for size in BATCH_UPLOAD_SIZES
        rates = run_simulation(size)  # Run simulation and store results
        push!(lastedFor, week)
        push!(nRecords, recordscreated)
        @info "Running simulation with batch upload size: $size"
        plot()
        @info "Plotting results for batch upload size: $size"
        plot!(1:week, rates, label="Batch size: $size")  # Add success rates to the plotxlabel!("Weeks")  # Label for x-axis
        ylabel!("Success Rate")  # Label for y-axis
        title!("Database Usability Over Time")  # Title of the plot
        # Save plot to a file
        savefig("database_usability_plot$size.png")  # Save the plot as a PNG file in the current directory
    end
    # println(lastedFor)
    return lastedFor, nRecords
end
function printStatistics(v)
    mean_val = mean(v)
    median_val = median(v)
    std_dev = std(v)
    variance_val = var(v)
    min_val = minimum(v)
    max_val = maximum(v)
    range_val = extrema(v) # Returns a tuple (min, max)
    q1 = quantile(v, 0.25) # First quartile (25th percentile)
    q3 = quantile(v, 0.75) # Third quartile (75th percentile)

    # Printing the results
    println("Vector: ", v)
    println("Mean: ", mean_val)
    println("Median: ", median_val)
    println("Standard Deviation: ", std_dev)
    println("Variance: ", variance_val)
    println("Minimum: ", min_val)
    println("Maximum: ", max_val)
    println("Range: ", range_val)
    println("First Quartile (Q1): ", q1)
    println("Third Quartile (Q3): ", q3)
end
runs = []
recordsamounts = []
for i in 1:15
    runres, nRecords = runSimForBSizes()
    push!(runs, runres)
    push!(recordsamounts, nRecords)
end
# println(runs)
recordsMatrix = hcat(recordsamounts...)
runsMatrix = hcat(runs...)
# println(runsMatrix)
for i in 1:length(BATCH_UPLOAD_SIZES)
    println("###### size $i")
    batchres = runsMatrix[i, :]
    println("#### runs")
    printStatistics(batchres)
    println("#### records")
    recordsRes = recordsMatrix[i, :]
    printStatistics(recordsRes)
end
# batch0 = runsMatrix[:, 1]
# batch1 = runsMatrix[:, 2]
# println(batch0)
# println(batch1)
