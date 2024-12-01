package main

import (
	"strconv"
	"strings"
)

const (
	Gt       = ">"
	Lt       = "<"
	Accepted = "A"
	Rejected = "R"
)

type Rule struct {
	category   string
	operation  string
	compareVal int
	result     string
}

type Workflow []Rule

type Workflows map[string]Workflow

type Part map[string]int

func parseRule(str string) Rule {
	if len(str) == 1 || (string(str[1]) != Gt && string(str[1]) != Lt) {
		return Rule{"", "", 0, str}
	}

	valueAndResultParts := strings.Split(str[2:], ":")
	compareVal, _ := strconv.Atoi(valueAndResultParts[0])

	return Rule{
		string(str[0]),
		string(str[1]),
		compareVal,
		valueAndResultParts[1],
	}
}

func parseWorkflow(line string) (string, Workflow) {
	// Remove traling "}" char
	line = line[:len(line)-1]

	workflowParts := strings.Split(line, "{")
	name := workflowParts[0]
	ruleParts := strings.Split(workflowParts[1], ",")
	rules := []Rule{}

	for i := 0; i < len(ruleParts); i++ {
		rules = append(rules, parseRule(ruleParts[i]))
	}

	return name, rules
}

func parsePart(line string) Part {
	// Remove leading "{" and traling "}" chars
	line = line[1 : len(line)-1]
	part := map[string]int{}
	categoriesParts := strings.Split(line, ",")

	for _, categoryPart := range categoriesParts {
		innerParts := strings.Split(categoryPart, "=")
		category := innerParts[0]
		value, _ := strconv.Atoi(innerParts[1])
		part[category] = value
	}

	return part
}

func applyWorkflow(part Part, workflow Workflow) string {
	for i := 0; i < len(workflow); i++ {
		rule := workflow[i]

		if rule.operation == "" {
			return rule.result
		}

		if rule.operation == Gt && part[rule.category] > rule.compareVal {
			return rule.result
		}

		if rule.operation == Lt && part[rule.category] < rule.compareVal {
			return rule.result
		}
	}

	panic("No rule was applicable!")
}

func applyWorkflows(part Part, workflows Workflows, initialWorkflow string) string {
	nextWorkflow := initialWorkflow

	for nextWorkflow != Accepted && nextWorkflow != Rejected {
		nextWorkflow = applyWorkflow(part, workflows[nextWorkflow])
	}

	return nextWorkflow
}

func nineteenPartOne(input string) int {
	workflows := Workflows{}
	parts := []Part{}
	inputParts := strings.Split(input, "\n\n")
	workflowLines := strings.Split(inputParts[0], "\n")
	partLines := strings.Split(inputParts[1], "\n")

	for i := 0; i < len(workflowLines); i++ {
		line := workflowLines[i]

		if len(line) == 0 {
			continue
		}

		name, workflow := parseWorkflow(line)
		workflows[name] = workflow
	}

	for i := 0; i < len(partLines); i++ {
		line := partLines[i]

		if len(line) == 0 {
			continue
		}

		part := parsePart(line)
		parts = append(parts, part)
	}

	acceptedParts := []Part{}

	for _, part := range parts {
		result := applyWorkflows(part, workflows, "in")

		if result == Accepted {
			acceptedParts = append(acceptedParts, part)
		}
	}

	result := 0

	for _, part := range acceptedParts {
		for _, val := range part {
			result += val
		}
	}

	return result
}

type NegatableRule struct {
	rule    Rule
	negated bool
}

type RuleTreePath struct {
	rules    []NegatableRule
	accepted bool
}

type RuleTree []RuleTreePath

type CategoryRange struct {
	min int
	max int
}

func buildRuleTree(rule Rule, workflows Workflows) RuleTree {
	if rule.category == "" {
		rules := []NegatableRule{{rule, false}}
		accepted := rule.result == Accepted

		return RuleTree{{rules, accepted}}
	}

	if rule.result == Accepted || rule.result == Rejected {
		rules := []NegatableRule{{rule, false}}
		negatedRules := []NegatableRule{{rule, true}}
		accepted := rule.result == Accepted

		return RuleTree{{rules, accepted}, {negatedRules, !accepted}}
	}

	startRules := []NegatableRule{{rule, false}}
	ruleTree := RuleTree{}

	nextWorkflow := workflows[rule.result]

	for i := 0; i < len(nextWorkflow); i++ {
		nextRule := nextWorkflow[i]
		previousRules := startRules

		for j := 0; j < i; j++ {
			previousRules = append(previousRules, NegatableRule{nextWorkflow[j], true})
		}

		treeFromNextRule := buildRuleTree(nextRule, workflows)

		for j := 0; j < len(treeFromNextRule); j++ {
			newRules := append(previousRules, treeFromNextRule[j].rules...)
			accepted := treeFromNextRule[j].accepted
			ruleTree = append(ruleTree, RuleTreePath{newRules, accepted})
		}
	}

	return ruleTree
}

func nineteenPartTwo(input string) int {
	workflows := Workflows{}
	inputParts := strings.Split(input, "\n\n")
	workflowLines := strings.Split(inputParts[0], "\n")

	for i := 0; i < len(workflowLines); i++ {
		line := workflowLines[i]

		if len(line) == 0 {
			continue
		}

		name, workflow := parseWorkflow(line)
		workflows[name] = workflow
	}

	startWorkflow := workflows["in"]
	ruleTree := RuleTree{}
	result := 0

	for i := 0; i < len(startWorkflow); i++ {
		rule := startWorkflow[i]
		previousRules := []NegatableRule{{rule, false}}

		for j := 0; j < i; j++ {
			previousRules = append(previousRules, NegatableRule{startWorkflow[j], true})
		}

		treeFromRule := buildRuleTree(rule, workflows)

		for j := 0; j < len(treeFromRule); j++ {
			path := treeFromRule[j]

			if !path.accepted {
				continue
			}

			newRules := append(previousRules, path.rules...)
			ruleTree = append(ruleTree, RuleTreePath{newRules, true})
		}
	}

	for _, path := range ruleTree {
		ranges := map[string]CategoryRange{
			"x": {1, 4000},
			"m": {1, 4000},
			"a": {1, 4000},
			"s": {1, 4000},
		}

		// len-1 because the last rule has no operation (just result=accepted)
		for i := 0; i < len(path.rules)-1; i++ {
			rule := path.rules[i]
			operation, negated, category, compareVal := rule.rule.operation, rule.negated, rule.rule.category, rule.rule.compareVal

			if (operation == Gt && !negated) || (operation == Lt && negated) {
				ranges[category] = CategoryRange{compareVal + 1, ranges[category].max}
			}

			if (operation == Lt && !negated) || (operation == Gt && negated) {
				ranges[category] = CategoryRange{ranges[category].min, compareVal - 1}
			}
		}

		hasInvalidRange := false
		rangesResult := 1

		for _, val := range ranges {
			if val.min > val.max {
				hasInvalidRange = true
				break
			}

			rangesResult *= val.max + 1 - val.min
		}

		if !hasInvalidRange {
			result += rangesResult
		}
	}

	return result
}

func nineteen(input string) (int, int) {
	return nineteenPartOne(input), nineteenPartTwo(input)
}
