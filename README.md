# Camera FPS

This is implemenetation of an application that helps to play around iPhone camera videos FPS.


## Video Stabilization
Cinematic video stabilization is available for connections that operate on video, depending on the specific device hardware. Even so, not all source formats and video resolutions are supported.

Enabling cinematic video stabilization may also introduce additional latency into the video capture pipeline. By default automatic stabilization is disabled due to this limitations.

## Video Preview
You can provide the user with a preview of what’s being recorded using an AVCaptureVideoPreviewLayer object. 
Using the AVCaptureVideoDataOutput class provides the client application with the ability to access the video pixels before they are presented to the user.

Unlike a capture output, a video preview layer maintains a strong reference to the session with which it is associated. This is to ensure that the session is not deallocated while the layer is attempting to display video.

### Video Gravity Modes
The preview layer supports three gravity modes that you set using videoGravity:

1. **AVLayerVideoGravityResizeAspect:** This preserves the aspect ratio, leaving black bars where the video does not fill the available screen area.
2. **AVLayerVideoGravityResizeAspectFill:** This preserves the aspect ratio, but fills the available screen area, cropping the video when necessary.
3. **AVLayerVideoGravityResize:** This simply stretches the video to fill the available screen area, even if doing so distorts the image.

## Settings/Configurations
1. You need to add the "Privacy - Camera usage description" key to your app’s Info.plist and their usage information, in order to gain access for Camera.

**Note:** 
1. Media capture does not support simultaneous capture of both the front-facing and back-facing cameras on iOS devices.
2. To set capture properties on a device, you must first acquire a lock on the device using lockForConfiguration:.
3. You should hold the device lock only if you need the settable device properties to remain unchanged. Holding the device lock unnecessarily may degrade capture quality in other applications sharing the device.
4. You must ensure that your implementation of **captureOutput:didOutputSampleBuffer:fromConnection:** is able to process a sample buffer within the amount of time allotted to a frame. If it takes too long and you hold onto the video frames, AV Foundation stops delivering frames, not only to your delegate but also to other outputs such as a preview layer.
5. You can use the capture video data output’s minFrameDuration property to be sure you have enough time to process a frame—at the cost of having a lower frame rate than would otherwise be the case. You might also make sure that the alwaysDiscardsLateVideoFrames property is set to YES (the default). This ensures that any late video frames are dropped rather than handed to you for processing. Alternatively, if you are recording and it doesn’t matter if the output fames are a little late and you would prefer to get all of them, you can set the property value to NO. This does not mean that frames will not be dropped (that is, frames may still be dropped), but that they may not be dropped as early, or as efficiently.

