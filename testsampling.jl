using StatsBase

# Valid weights
weights1 = [1, 2, 3, 4]
weights2 = [0.1, 0.2, 0.3, 0.4]
weights3 = [0, 0, 0, 0] # Some weights can be zero

# Invalid weights
# weights4 = [-1, 2, 3] # Negative weight: ERROR
# weights5 = [0, 0, 0]   # All weights are zero: ERROR

population = ['a', 'b', 'c', 'd']

# Sample with replacement using weights1
samples1 = sample(1:length(population), Weights(weights1))
println("Samples with weights1: ", samples1)

# Sample without replacement using weights1
samples2 = sample(population, Weights(weights1), 3)
println("Samples without replacement with weights1: ", samples2)

# Sample with replacement using weights2 (same probabilities as weights1)
samples3 = sample(population, Weights(weights2), 10, replace=true)
println("Samples with weights2: ", samples3)

# Sample with replacement using weights3
samples4 = sample(population, Weights(weights3), 10, replace=true)
println("Samples with weights3: ", samples4)


# using StatsBase
#
# population = ['a', 'b', 'c', 'd', 'e']
# weights = [1, 2, 3, 4, 5]
#
# # StatsBase.sample() with replacement (weighted)
# samples_sample = sample(population, Weights(weights), 5, replace=true)
# println("StatsBase.sample() (with replacement): ", samples_sample, " (Type: ", typeof(samples_sample), ", Element Type: ", eltype(samples_sample), ")")
#
# # StatsBase.wsample() (weighted with replacement)
# indices_wsample = wsample(1:length(population), weights, 5) # Note: population index range is used
# sampled_elements_wsample = population[indices_wsample] # Access the sampled elements
# println("StatsBase.wsample() (with replacement): ", sampled_elements_wsample, " (Type: ", typeof(sampled_elements_wsample), ", Element Type: ", eltype(sampled_elements_wsample), ")")
# println("StatsBase.wsample() (indices): ", indices_wsample, " (Type: ", typeof(indices_wsample), ", Element Type: ", eltype(indices_wsample), ")")
#
#
# # Random.sample() without replacement (weighted)
# probabilities = weights ./ sum(weights)
# samples_random = sample(population, 3, replace=false, p=probabilities)
# println("Random.sample() (without replacement): ", samples_random, " (Type: ", typeof(samples_random), ", Element Type: ", eltype(samples_random), ")")
#
# #Random.sample() with replacement (weighted)
# samples_random_replace = sample(population, 5, replace=true, p=probabilities)
# println("Random.sample() (with replacement): ", samples_random_replace, " (Type: ", typeof(samples_random_replace), ", Element Type: ", eltype(samples_random_replace), ")")
