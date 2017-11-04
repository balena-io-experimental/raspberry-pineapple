# raspberry-pineapple
Build your own WiFi Pineapple, with Resin.io and a raspberry pi

## Getting started

- Set up a raspberry pi 3
    * (Could be used for other devices too, but you'll need to change the base image in the Dockerfile)
- Sign up for free on [resin.io](https://dashboard.resin.io/signup), create an application for your device, and follow the instructions to provision it.
- Connect the device to the internet with a network cable
- Push the contents of this repo to your Resin.io application
- Your device will start a wifi hotspot called `intercepting-wifi`.
- Connect to the hotspot. Internet will work as normal, except for [example.com](http://example.com), which will be rewritten.

## Configuration

There's a few built in configuration options, which can be set with environment variables for the application in your dashboard:

* `HOTSPOT_NAME` - the name of the hotspot to create. Defaults to `intercepting-wifi`
* `OUT_INTERFACE` - the upstream interface that real internet will come from. Defaults to `eth0`: the ethernet connection. Change to `usb0` to use a usb-tethered mobile connection.
* `TARGET_HOST` - the host to override: any HTTP requests to hosts including this string will be rewritten.

## Legal warning

This demo is designed to be used to demonstrate and test security issues, by allowing you to easily intercept & transform simple real world traffic.

**Do not intercept people's traffic without their consent!** In most of the world this is a crime. Ensure your hotspot is clearly named so that connecting clients
are aware of what it is, or otherwise make sure your connecting users know what they're getting themselves into.