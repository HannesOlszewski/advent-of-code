package main

import (
	"slices"
	"strconv"
	"strings"
)

type Mapping struct {
	firstSource int
	lastSource  int
	firstTarget int
	lastTarget  int
}

func parseMapping(mappingLines []string) []Mapping {
	mappings := []Mapping{}

	for _, line := range mappingLines {
		parts := strings.Split(line, " ")
		firstTarget, _ := strconv.Atoi(parts[0])
		firstSource, _ := strconv.Atoi(parts[1])
		ranges, _ := strconv.Atoi(parts[2])

		mappings = append(mappings, Mapping{
			firstSource: firstSource,
			lastSource:  firstSource + ranges - 1,
			firstTarget: firstTarget,
			lastTarget:  firstTarget + ranges - 1,
		})
	}

	slices.SortFunc(mappings, func(a, b Mapping) int {
		return a.firstTarget - b.firstTarget
	})

	return mappings
}

func findSourceMappings(firstTarget int, lastTarget int, mappings []Mapping) []Mapping {
	sourceMappings := []Mapping{}

	for _, mapping := range mappings {
		if mapping.firstTarget <= firstTarget && mapping.lastTarget >= lastTarget {
			sourceMappings = append(sourceMappings, Mapping{
				firstSource: mapping.firstSource + (firstTarget - mapping.firstTarget),
				lastSource:  mapping.firstSource + (lastTarget - mapping.firstTarget),
				firstTarget: firstTarget,
				lastTarget:  lastTarget,
			})
		}

		if mapping.firstTarget >= firstTarget && mapping.lastTarget <= lastTarget {
			sourceMappings = append(sourceMappings, mapping)
		}

		if mapping.firstTarget <= firstTarget && mapping.lastTarget <= lastTarget && mapping.lastTarget >= firstTarget {
			sourceMappings = append(sourceMappings, Mapping{
				firstTarget: firstTarget,
				lastTarget:  mapping.lastTarget,
				firstSource: mapping.firstSource + (firstTarget - mapping.firstTarget),
				lastSource:  mapping.lastSource,
			})
		}

		if mapping.firstTarget >= firstTarget && mapping.lastTarget >= lastTarget && mapping.firstTarget <= lastTarget {
			sourceMappings = append(sourceMappings, Mapping{
				firstTarget: mapping.firstTarget,
				lastTarget:  lastTarget,
				firstSource: mapping.firstSource,
				lastSource:  mapping.lastSource - (mapping.lastTarget - lastTarget),
			})
		}
	}

	if len(sourceMappings) == 0 {
		sourceMappings = append(sourceMappings, Mapping{
			firstTarget: firstTarget,
			lastTarget:  lastTarget,
			firstSource: firstTarget,
			lastSource:  lastTarget,
		})
	}

	return sourceMappings
}

func findTargetMappings(firstSource int, lastSource int, mappings []Mapping) []Mapping {
	targetMappings := []Mapping{}

	for _, mapping := range mappings {
		if mapping.firstSource <= firstSource && mapping.lastSource >= lastSource {
			targetMappings = append(targetMappings, Mapping{
				firstTarget: mapping.firstTarget + (firstSource - mapping.firstSource),
				lastTarget:  mapping.firstTarget + (lastSource - mapping.firstSource),
				firstSource: firstSource,
				lastSource:  lastSource,
			})
		}

		if mapping.firstSource >= firstSource && mapping.lastSource <= lastSource {
			targetMappings = append(targetMappings, mapping)
		}

		if mapping.firstSource <= firstSource && mapping.lastSource <= lastSource && mapping.lastSource >= firstSource {
			targetMappings = append(targetMappings, Mapping{
				firstSource: firstSource,
				lastSource:  mapping.lastSource,
				firstTarget: mapping.firstTarget + (firstSource - mapping.firstSource),
				lastTarget:  mapping.lastTarget,
			})
		}

		if mapping.firstSource >= firstSource && mapping.lastSource >= lastSource && mapping.firstSource <= lastSource {
			targetMappings = append(targetMappings, Mapping{
				firstSource: mapping.firstSource,
				lastSource:  lastSource,
				firstTarget: mapping.firstTarget,
				lastTarget:  mapping.lastTarget - (mapping.lastSource - lastSource),
			})
		}
	}

	if len(targetMappings) == 0 {
		targetMappings = append(targetMappings, Mapping{
			firstTarget: firstSource,
			lastTarget:  lastSource,
			firstSource: firstSource,
			lastSource:  lastSource,
		})
	}

	return targetMappings
}

func fivePartOne(input string) int {
	inputParts := strings.Split(input, "\n\n")
	seeds := strings.Split(inputParts[0], " ")[1:]
	seedToSoilMap := parseMapping(strings.Split(inputParts[1], "\n")[1:])
	soilToFertilizerMap := parseMapping(strings.Split(inputParts[2], "\n")[1:])
	fertilizerToWaterMap := parseMapping(strings.Split(inputParts[3], "\n")[1:])
	waterToLightMap := parseMapping(strings.Split(inputParts[4], "\n")[1:])
	lightToTemperatureMap := parseMapping(strings.Split(inputParts[5], "\n")[1:])
	temperatureToHumidityMap := parseMapping(strings.Split(inputParts[6], "\n")[1:])
	humidityToLocationMap := parseMapping(strings.Split(inputParts[7], "\n")[1:])

	minLocation := -1

	for _, seed := range seeds {
		seedAsInt, _ := strconv.Atoi(seed)
		sToSMappings := findTargetMappings(seedAsInt, seedAsInt, seedToSoilMap)

		for _, sToSMapping := range sToSMappings {
			sToFMappings := findTargetMappings(sToSMapping.firstTarget, sToSMapping.lastTarget, soilToFertilizerMap)

			for _, sToFMapping := range sToFMappings {
				fToWMappings := findTargetMappings(sToFMapping.firstTarget, sToFMapping.lastTarget, fertilizerToWaterMap)

				for _, fToWMapping := range fToWMappings {
					wToLMappings := findTargetMappings(fToWMapping.firstTarget, fToWMapping.lastTarget, waterToLightMap)

					for _, wToLMapping := range wToLMappings {
						lToTMappings := findTargetMappings(wToLMapping.firstTarget, wToLMapping.lastTarget, lightToTemperatureMap)

						for _, lToTMapping := range lToTMappings {
							tToHMappings := findTargetMappings(lToTMapping.firstTarget, lToTMapping.lastTarget, temperatureToHumidityMap)

							for _, tToHMapping := range tToHMappings {
								hToLMappings := findTargetMappings(tToHMapping.firstTarget, tToHMapping.lastTarget, humidityToLocationMap)

								for _, hToLMapping := range hToLMappings {
									if minLocation == -1 || hToLMapping.firstTarget < minLocation {
										minLocation = hToLMapping.firstTarget
									}
								}
							}
						}
					}
				}
			}
		}
	}

	return minLocation
}

func fivePartTwo(input string) int {
	inputParts := strings.Split(input, "\n\n")
	seedsNumbers := strings.Split(inputParts[0], " ")[1:]
	seedToSoilMap := parseMapping(strings.Split(inputParts[1], "\n")[1:])
	soilToFertilizerMap := parseMapping(strings.Split(inputParts[2], "\n")[1:])
	fertilizerToWaterMap := parseMapping(strings.Split(inputParts[3], "\n")[1:])
	waterToLightMap := parseMapping(strings.Split(inputParts[4], "\n")[1:])
	lightToTemperatureMap := parseMapping(strings.Split(inputParts[5], "\n")[1:])
	temperatureToHumidityMap := parseMapping(strings.Split(inputParts[6], "\n")[1:])
	humidityToLocationMap := parseMapping(strings.Split(inputParts[7], "\n")[1:])

	if humidityToLocationMap[0].firstTarget > 0 {
		mapRange := humidityToLocationMap[0].firstTarget

		humidityToLocationMap = slices.Insert(humidityToLocationMap, 0, Mapping{
			firstSource: 0,
			lastSource:  mapRange - 1,
			firstTarget: 0,
			lastTarget:  mapRange - 1,
		})
	}

	seeds := []Mapping{}

	for i := 0; i < len(seedsNumbers); i += 2 {
		firstSeed, _ := strconv.Atoi(seedsNumbers[i])
		seedRange, _ := strconv.Atoi(seedsNumbers[i+1])
		lastSeed := firstSeed + seedRange - 1

		seeds = append(seeds, Mapping{
			firstSource: firstSeed,
			firstTarget: firstSeed,
			lastSource:  lastSeed,
			lastTarget:  lastSeed,
		})
	}

	for _, hToLMapping := range humidityToLocationMap {
		tToHMappings := findSourceMappings(hToLMapping.firstSource, hToLMapping.lastSource, temperatureToHumidityMap)

		for _, tToHMapping := range tToHMappings {
			lToTMappings := findSourceMappings(tToHMapping.firstSource, tToHMapping.lastSource, lightToTemperatureMap)

			for _, lToTMapping := range lToTMappings {
				wToLMappings := findSourceMappings(lToTMapping.firstSource, lToTMapping.lastSource, waterToLightMap)

				for _, wToLMapping := range wToLMappings {
					fToWMappings := findSourceMappings(wToLMapping.firstSource, wToLMapping.lastSource, fertilizerToWaterMap)

					for _, fToWMapping := range fToWMappings {
						sToFMappings := findSourceMappings(fToWMapping.firstSource, fToWMapping.lastSource, soilToFertilizerMap)

						for _, sToFMapping := range sToFMappings {
							sToSMappings := findSourceMappings(sToFMapping.firstSource, sToFMapping.lastSource, seedToSoilMap)

							for _, sToSMapping := range sToSMappings {
								for _, seed := range seeds {
									firstSeed := -1

									if seed.firstSource <= sToSMapping.firstSource && seed.lastSource >= sToSMapping.lastSource {
										firstSeed = sToSMapping.firstSource
									}

									if seed.firstSource >= sToSMapping.firstSource && seed.lastSource <= sToSMapping.lastSource {
										firstSeed = seed.firstSource
									}

									if seed.firstSource <= sToSMapping.firstSource && seed.lastSource <= sToSMapping.lastSource && seed.lastSource >= sToSMapping.firstSource {
										firstSeed = sToSMapping.firstSource
									}

									if seed.firstSource >= sToSMapping.firstSource && seed.lastSource >= sToSMapping.lastSource && seed.firstSource <= sToSMapping.lastSource {
										firstSeed = seed.firstSource
									}

									if firstSeed != -1 {
										soil := sToSMapping.firstTarget + (firstSeed - sToSMapping.firstSource)
										fertilizer := sToFMapping.firstTarget + (soil - sToFMapping.firstSource)
										water := fToWMapping.firstTarget + (fertilizer - fToWMapping.firstSource)
										light := wToLMapping.firstTarget + (water - wToLMapping.firstSource)
										temperature := lToTMapping.firstTarget + (light - lToTMapping.firstSource)
										humidity := tToHMapping.firstTarget + (temperature - tToHMapping.firstSource)
										location := hToLMapping.firstTarget + (humidity - hToLMapping.firstSource)

										return location
									}
								}
							}
						}
					}
				}
			}
		}
	}

	return -1
}

func five(input string) (int, int) {
	return fivePartOne(input), fivePartTwo(input)
}
