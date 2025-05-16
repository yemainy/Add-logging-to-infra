# get hosted zone details
# terraform aws data hosted zone
data "aws_route53_zone" "hosted_zone" {
  name = "apexminders.com"
}

# create a record set in route 53
# terraform aws route 53 record
resource "aws_route53_record" "site_domain" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  #Keeps your logging/monitoring separate from your main website
  name    = "logs.apexminders.com"
  type    = "A" # Routes traffic to an IPv4 address and some AWS resources (A)

  alias {
    name                   = aws_lb.yemi_logready_alb.dns_name
    zone_id                = aws_lb.yemi_logready_alb.zone_id
    evaluate_target_health = true
  }
}