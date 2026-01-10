docker run -d \
--name rdp-client \
--net=host \
-e DISPLAY=$DISPLAY \
-v /tmp/.X11-unix:/tmp/.X11-unix \
rdp-client-image
