resource "aws_flow_log" "vpc1-us-east-1" {
  iam_role_arn    = "arn:aws:iam::873060941818:role/vpc-flow-flows"    //This is hardcoded because we don't want it destroyed
  log_destination = "${aws_cloudwatch_log_group.vpc-flow-useast1.arn}"
  traffic_type    = "ALL"
  vpc_id          = "${module.vpc1-us-east-1.vpc_id}"
}

resource "aws_cloudwatch_log_group" "vpc-flow-useast1" {
  name = "vpc-flow-logs"
}
