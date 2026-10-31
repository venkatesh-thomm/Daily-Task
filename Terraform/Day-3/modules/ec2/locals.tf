locals {
  common_tags = merge(
    var.tags,
    var.common_tags,
    {
      Environment = var.environment
    }
  )
}
