interface Mapping {
  firstTarget: number;
  lastTarget: number;
  firstSource: number;
  lastSource: number;
}

function parseMapping(mappingLines: Array<string>): Array<Mapping> {
  return mappingLines
    .map((line) => {
      const parts = line.split(" ");
      const firstTarget = Number.parseInt(parts[0]);
      const firstSource = Number.parseInt(parts[1]);
      const ranges = Number.parseInt(parts[2]);

      return {
        firstTarget,
        lastTarget: firstTarget + ranges - 1,
        firstSource,
        lastSource: firstSource + ranges - 1,
      };
    })
    .sort((a, b) => a.firstTarget - b.firstTarget);
}

function findTarget(source: number, mappings: Array<Mapping>): number {
  for (const mapping of mappings) {
    if (source >= mapping.firstSource && source <= mapping.lastSource) {
      return mapping.firstTarget + (source - mapping.firstSource);
    }
  }

  return source;
}

function findSourceMappings(
  firstTarget: number,
  lastTarget: number,
  mappings: Array<Mapping>,
): Array<Mapping> {
  const sourceMappings: Array<Mapping> = [];

  for (const mapping of mappings) {
    if (
      mapping.firstTarget <= firstTarget &&
      mapping.lastTarget >= lastTarget
    ) {
      sourceMappings.push({
        firstTarget,
        lastTarget,
        firstSource: mapping.firstSource + (firstTarget - mapping.firstTarget),
        lastSource: mapping.firstSource + (lastTarget - mapping.firstTarget),
      });
    }

    if (
      mapping.firstTarget >= firstTarget &&
      mapping.lastTarget <= lastTarget
    ) {
      sourceMappings.push(mapping);
    }

    if (
      mapping.firstTarget <= firstTarget &&
      mapping.lastTarget <= lastTarget &&
      mapping.lastTarget >= firstTarget
    ) {
      sourceMappings.push({
        firstTarget,
        lastTarget: mapping.lastTarget,
        firstSource: mapping.firstSource + (firstTarget - mapping.firstTarget),
        lastSource: mapping.lastSource,
      });
    }

    if (
      mapping.firstTarget >= firstTarget &&
      mapping.lastTarget >= lastTarget &&
      mapping.firstTarget <= lastTarget
    ) {
      sourceMappings.push({
        firstTarget: mapping.firstTarget,
        lastTarget,
        firstSource: mapping.firstSource,
        lastSource: mapping.firstSource + (lastTarget - mapping.firstTarget),
      });
    }
  }

  if (sourceMappings.length === 0) {
    sourceMappings.push({
      firstTarget,
      lastTarget,
      firstSource: firstTarget,
      lastSource: lastTarget,
    });
  }

  return sourceMappings;
}

export function partOne(input: string): number {
  const inputParts = input.split("\n\n");
  const seeds = inputParts[0].split(" ").slice(1).map(Number);
  const seedToSoilMap = parseMapping(inputParts[1].split("\n").slice(1));
  const soilToFertilizerMap = parseMapping(inputParts[2].split("\n").slice(1));
  const fertilizerToWaterMap = parseMapping(inputParts[3].split("\n").slice(1));
  const waterToLightMap = parseMapping(inputParts[4].split("\n").slice(1));
  const lightToTemperatureMap = parseMapping(
    inputParts[5].split("\n").slice(1),
  );
  const temperatureToHumidityMap = parseMapping(
    inputParts[6].split("\n").slice(1),
  );
  const humidityToLocationMap = parseMapping(
    inputParts[7].split("\n").slice(1),
  );

  let minLocation = -1;

  for (const seed of seeds) {
    const soil = findTarget(seed, seedToSoilMap);
    const fertilizer = findTarget(soil, soilToFertilizerMap);
    const water = findTarget(fertilizer, fertilizerToWaterMap);
    const light = findTarget(water, waterToLightMap);
    const temperature = findTarget(light, lightToTemperatureMap);
    const humidity = findTarget(temperature, temperatureToHumidityMap);
    const location = findTarget(humidity, humidityToLocationMap);

    if (minLocation === -1 || location < minLocation) {
      minLocation = location;
    }
  }

  return minLocation;
}

export function partTwo(input: string): number {
  const inputParts = input.split("\n\n");
  const seedsParts = inputParts[0].split(" ").slice(1);
  const seeds: Array<Mapping> = [];
  for (let i = 0; i < seedsParts.length; i += 2) {
    const first = Number.parseInt(seedsParts[i]);
    const range = Number.parseInt(seedsParts[i + 1]);

    seeds.push({
      firstSource: first,
      lastSource: first + range - 1,
      firstTarget: first,
      lastTarget: first + range - 1,
    });
  }
  const seedToSoilMap = parseMapping(inputParts[1].split("\n").slice(1));
  const soilToFertilizerMap = parseMapping(inputParts[2].split("\n").slice(1));
  const fertilizerToWaterMap = parseMapping(inputParts[3].split("\n").slice(1));
  const waterToLightMap = parseMapping(inputParts[4].split("\n").slice(1));
  const lightToTemperatureMap = parseMapping(
    inputParts[5].split("\n").slice(1),
  );
  const temperatureToHumidityMap = parseMapping(
    inputParts[6].split("\n").slice(1),
  );
  const humidityToLocationMap = parseMapping(
    inputParts[7].split("\n").slice(1),
  );

  if (humidityToLocationMap[0].firstTarget > 0) {
    humidityToLocationMap.unshift({
      firstSource: 0,
      lastSource: humidityToLocationMap[0].firstSource - 1,
      firstTarget: 0,
      lastTarget: humidityToLocationMap[0].firstSource - 1,
    });
  }

  for (const locationMapping of humidityToLocationMap) {
    const humidityMappings = findSourceMappings(
      locationMapping.firstSource,
      locationMapping.lastSource,
      humidityToLocationMap,
    );

    for (const humidityMapping of humidityMappings) {
      const temperatureMappings = findSourceMappings(
        humidityMapping.firstSource,
        humidityMapping.lastSource,
        temperatureToHumidityMap,
      );

      for (const temperatureMapping of temperatureMappings) {
        const lightMappings = findSourceMappings(
          temperatureMapping.firstSource,
          temperatureMapping.lastSource,
          lightToTemperatureMap,
        );

        for (const lightMapping of lightMappings) {
          const waterMappings = findSourceMappings(
            lightMapping.firstSource,
            lightMapping.lastSource,
            waterToLightMap,
          );

          for (const waterMapping of waterMappings) {
            const fertilizerMappings = findSourceMappings(
              waterMapping.firstSource,
              waterMapping.lastSource,
              fertilizerToWaterMap,
            );

            for (const fertilizerMapping of fertilizerMappings) {
              const soilMappings = findSourceMappings(
                fertilizerMapping.firstSource,
                fertilizerMapping.lastSource,
                soilToFertilizerMap,
              );

              for (const soilMapping of soilMappings) {
                const seedMappings = findSourceMappings(
                  soilMapping.firstSource,
                  soilMapping.lastSource,
                  seedToSoilMap,
                );

                for (const seedMapping of seedMappings) {
                  for (const seed of seeds) {
                    let firstSeed = -1;

                    if (
                      seed.firstSource <= seedMapping.firstSource &&
                      seed.lastSource >= seedMapping.lastSource
                    ) {
                      firstSeed = seedMapping.firstSource;
                    }

                    if (
                      seed.firstSource >= seedMapping.firstSource &&
                      seed.lastSource <= seedMapping.lastSource
                    ) {
                      firstSeed = seed.firstSource;
                    }

                    if (
                      seed.firstSource <= seedMapping.firstSource &&
                      seed.lastSource <= seedMapping.lastSource &&
                      seed.lastSource >= seedMapping.firstSource
                    ) {
                      firstSeed = seedMapping.firstSource;
                    }

                    if (
                      seed.firstSource >= seedMapping.firstSource &&
                      seed.lastSource >= seedMapping.lastSource &&
                      seed.firstSource <= seedMapping.lastSource
                    ) {
                      firstSeed = seed.firstSource;
                    }

                    if (firstSeed !== -1) {
                      const soil = findTarget(firstSeed, seedToSoilMap);
                      const fertilizer = findTarget(soil, soilToFertilizerMap);
                      const water = findTarget(
                        fertilizer,
                        fertilizerToWaterMap,
                      );
                      const light = findTarget(water, waterToLightMap);
                      const temperature = findTarget(
                        light,
                        lightToTemperatureMap,
                      );
                      const humidity = findTarget(
                        temperature,
                        temperatureToHumidityMap,
                      );
                      const location = findTarget(
                        humidity,
                        humidityToLocationMap,
                      );

                      return location;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  return -1;
}

export function dayFive(input: string): [number, number] {
  return [partOne(input), partTwo(input)];
}
