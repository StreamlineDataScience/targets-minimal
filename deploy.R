# trailrun::deploy_renv(".")

library(trailrun)
library(googleCloudRunner)
path = "."
image_base = basename(normalizePath(path))
image_base = paste0("streamliner-", image_base)
image = streamline_private_image(image_base)
# if renv-base updates or the renv.lock file,
# uncomment these lines.  Ideally you rebuild the image when renv.lock
# changes!  - This should be the trigger
tagged_image = paste0(image, ":", c("latest", "$BUILD_ID"))
trailrun::deploy_renv(path, tagged_image = tagged_image, push_image = TRUE)

trailrun::cr_gce_setup(bucket = image_base)
bs <- cr_buildstep_targets_multi(
  task_image = image,
  bucket = image_base,
  task_args = list(r_cmd = "R")
)

# run it immediately in cloud
cr_build_targets(bs, execute="now")
