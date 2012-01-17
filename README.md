This is a test project that I'm using to play with Core Location background notifications.

Not sure if it will eventually be useful to anyone else, but I doubt it is now (I've at least made no attempt so far to document 
what I'm doing or why).

It uses my fork of [JucheLog](https://github.com/drewcrawford/JucheLog) to log events in the background (since part of the point
of background notifications to me is seeing if I can talk to the network from the background).

To use Loggly, you'll have to create a file called:

```CLSpike/Loggly_API_Key.h```

Which contains:
```
#define kLOGGLY_API_KEY @"YOUR-GUID-GOES-HERE"
```

Bugs: There's currently no UI to speak of.