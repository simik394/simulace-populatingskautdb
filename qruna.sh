#!/bin/bash
julia simulace-nobatch.jl
cat simulation.log |grep rate|tail -n 10
