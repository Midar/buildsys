### nenolod's buildsys fork

This is a custom version of [buildsys] (http://github.com/Midar/buildsys), designed for
massively parallel builds.  The differences between official buildsys and this buildsys
are:

* A large amount of shell has been replaced with gmake builtin rule generation features.

* You can use V=1 to get CFLAGS and LDFLAGS passed to commands.

* Multiple `SUBDIRS` may be compiled in parallel.  This ensures that there are no stalls
  in the build process on multi-core boxes.  If there is anything to build, we will be
  building it.

* Dependency generation is on a per-sourceunit basis and done entirely in parallel, including
  across multiple `SUBDIRS`.  This speeds up builds by allowing dependency generation to
  already be completed when you get deeper in the source tree.

* The messages produced by the buildsystem have been changed so that V=1 output doesn't
  look strange.

Other than that, it is mostly compatible with official buildsys at an "API level."

In terms of performance increase, on stock buildsys, make -j4 takes around 50 seconds
to build audacious-plugins.  On this fork, the build time is cut down to around 20
seconds.  That's a pretty big increase.

### Possible problems / FAQ

#### I am getting notices about missing libraries that should be built already!

The way we parallelize SUBDIRS is by converting each SUBDIR into a make task.  If a specific
SUBDIR depends on another SUBDIR, you should denote it like so:

```Make
SUBDIRS = subdir1 subdir2 subdir3 subdir4

# subdir2 depends on subdir1
subdir2: subdir1

# subdir3 depends on both subdir1 and subdir4
subdir3: subdir2 subdir4
```

This results in subdir1 and subdir4 being built first, then subdir2 and subdir3
respectively.

#### It won't build my SUBDIRS.

Put your SUBDIRS before your include lines.  You really are supposed to do this in
buildsys *anyway*, but for some reason it sometimes lets you put it after the fact.

My fork does not let you do that as SUBDIRS are turned into make tasks.

#### It doesn't work with FreeBSD make, NetBSD make, or some other non-GNU make

Sorry, but in order to avoid using the shell unnecessarily, we have to depend on
GNU-make specific behaviour.  Use gmake instead.
