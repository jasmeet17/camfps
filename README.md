# Camera FPS

This is implemenetation of an application that helps to play around iPhone camera videos FPS.


## Video Stabilization
Cinematic video stabilization is available for connections that operate on video, depending on the specific device hardware. Even so, not all source formats and video resolutions are supported.

Enabling cinematic video stabilization may also introduce additional latency into the video capture pipeline. By default automatic stabilization is disabled due to this limitations.


Note: 
1. Media capture does not support simultaneous capture of both the front-facing and back-facing cameras on iOS devices.
2. To set capture properties on a device, you must first acquire a lock on the device using lockForConfiguration:.
3. You should hold the device lock only if you need the settable device properties to remain unchanged. Holding the device lock unnecessarily may degrade capture quality in other applications sharing the device.
