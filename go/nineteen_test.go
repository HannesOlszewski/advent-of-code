package main

import "testing"

func TestNineteenPartOne(t *testing.T) {
	input := `px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}`

	expected := 19114

	if actual := nineteenPartOne(input); actual != expected {
		t.Fatalf("Expected %d but was %d", expected, actual)
	}
}

func TestNineteenPartTwo(t *testing.T) {
	input := `px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}`

	expected := 167409079868000

	if actual := nineteenPartTwo(input); actual != expected {
		t.Fatalf("Expected %d but was %d", expected, actual)
	}
}

func TestBuildRuleTree(t *testing.T) {
	workflows := Workflows{}
	workflows["px"] = Workflow{{"a", "<", 2006, "qkq"}, {"m", ">", 2090, "A"}, {"", "", 0, "rfg"}}
	workflows["pv"] = Workflow{{"a", ">", 1716, "R"}, {"", "", 0, "A"}}
	workflows["lnx"] = Workflow{{"m", ">", 1548, "A"}, {"", "", 0, "A"}}
	workflows["rfg"] = Workflow{{"s", "<", 537, "gd"}, {"x", ">", 2440, "R"}, {"", "", 0, "A"}}
	workflows["qs"] = Workflow{{"s", ">", 3448, "A"}, {"", "", 0, "lnx"}}
	workflows["qkq"] = Workflow{{"x", "<", 1416, "A"}, {"", "", 0, "crn"}}
	workflows["crn"] = Workflow{{"x", ">", 2662, "A"}, {"", "", 0, "R"}}
	workflows["in"] = Workflow{{"s", "<", 1351, "px"}, {"", "", 0, "qqz"}}
	workflows["qqz"] = Workflow{{"s", ">", 2770, "qs"}, {"m", "<", 1801, "hdj"}, {"", "", 0, "R"}}
	workflows["gd"] = Workflow{{"a", ">", 3333, "R"}, {"", "", 0, "R"}}
	workflows["hdj"] = Workflow{{"m", ">", 838, "A"}, {"", "", 0, "pv"}}

	// rule1 := Rule{"m", ">", 838, "A"}
	// expected1 := RuleTree{{{{"m", ">", 838, "A"}, false}, {{"m", ">", 838, "A"}, }}}
}
