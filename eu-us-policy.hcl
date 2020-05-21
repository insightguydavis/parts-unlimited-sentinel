# NOTE that you must explicitly specify availability_zone on all aws_instances 
import "tfplan"
# Get all AWS instances from all modules
aws_instances = func() {
    instances = []
    for tfplan.module_paths as path {
        instances += values(tfplan.module(path).resources.aws_instance) else []
    }
    return instances
}
# Allowed availability zones
allowed_zones_as_regex = [
  "^us",
  "^eu"
]
# Rule to restrict availability zones and region
main = rule {
    all aws_instances() as _, instances {
      all instances as index, r {
        all allowed_zones_as_regex as zi, az 
         r.applied.availability_zone match az
      }
    }
}