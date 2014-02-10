# GNU Make project makefile autogenerated by Premake
ifndef config
  config=debug
endif

ifndef verbose
  SILENT = @
endif

ifndef CC
  CC = gcc
endif

ifndef CXX
  CXX = g++
endif

ifndef AR
  AR = ar
endif

ifeq ($(config),debug)
  OBJDIR     = ../obj/Debug/lpeg
  TARGETDIR  = ../bin/Debug
  TARGET     = $(TARGETDIR)/liblpeg.a
  DEFINES   += -DGLEW_STATIC
  INCLUDES  += -I../src -I../src/luasocket -I../src/fov -I../src/expat -I../src/lxp -I../src/libtcod_import -I../src/physfs -I../src/zlib -I../src/bzip2 -I/usr/include/SDL2 -I/usr/include/GL -I../src/luajit2/src -I../src/luajit2/dynasm
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -g
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += 
  LIBS      += 
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LDDEPS    += 
  LINKCMD    = $(AR) -rcs $(TARGET) $(OBJECTS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),release)
  OBJDIR     = ../obj/Release/lpeg
  TARGETDIR  = ../bin/Release
  TARGET     = $(TARGETDIR)/liblpeg.a
  DEFINES   += -DGLEW_STATIC -DNDEBUG=1
  INCLUDES  += -I../src -I../src/luasocket -I../src/fov -I../src/expat -I../src/lxp -I../src/libtcod_import -I../src/physfs -I../src/zlib -I../src/bzip2 -I/usr/include/SDL2 -I/usr/include/GL -I../src/luajit2/src -I../src/luajit2/dynasm
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -fomit-frame-pointer -O2
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -s
  LIBS      += 
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LDDEPS    += 
  LINKCMD    = $(AR) -rcs $(TARGET) $(OBJECTS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

OBJECTS := \
	$(OBJDIR)/lpvm.o \
	$(OBJDIR)/lpcode.o \
	$(OBJDIR)/lptree.o \
	$(OBJDIR)/lpprint.o \
	$(OBJDIR)/lpcap.o \

RESOURCES := \

SHELLTYPE := msdos
ifeq (,$(ComSpec)$(COMSPEC))
  SHELLTYPE := posix
endif
ifeq (/bin,$(findstring /bin,$(SHELL)))
  SHELLTYPE := posix
endif

.PHONY: clean prebuild prelink

all: $(TARGETDIR) $(OBJDIR) prebuild prelink $(TARGET)
	@:

$(TARGET): $(GCH) $(OBJECTS) $(LDDEPS) $(RESOURCES)
	@echo Linking lpeg
	$(SILENT) $(LINKCMD)
	$(POSTBUILDCMDS)

$(TARGETDIR):
	@echo Creating $(TARGETDIR)
ifeq (posix,$(SHELLTYPE))
	$(SILENT) mkdir -p $(TARGETDIR)
else
	$(SILENT) mkdir $(subst /,\\,$(TARGETDIR))
endif

$(OBJDIR):
	@echo Creating $(OBJDIR)
ifeq (posix,$(SHELLTYPE))
	$(SILENT) mkdir -p $(OBJDIR)
else
	$(SILENT) mkdir $(subst /,\\,$(OBJDIR))
endif

clean:
	@echo Cleaning lpeg
ifeq (posix,$(SHELLTYPE))
	$(SILENT) rm -f  $(TARGET)
	$(SILENT) rm -rf $(OBJDIR)
else
	$(SILENT) if exist $(subst /,\\,$(TARGET)) del $(subst /,\\,$(TARGET))
	$(SILENT) if exist $(subst /,\\,$(OBJDIR)) rmdir /s /q $(subst /,\\,$(OBJDIR))
endif

prebuild:
	$(PREBUILDCMDS)

prelink:
	$(PRELINKCMDS)

ifneq (,$(PCH))
$(GCH): $(PCH)
	@echo $(notdir $<)
	-$(SILENT) cp $< $(OBJDIR)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
endif

$(OBJDIR)/lpvm.o: ../src/lpeg/lpvm.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lpcode.o: ../src/lpeg/lpcode.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lptree.o: ../src/lpeg/lptree.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lpprint.o: ../src/lpeg/lpprint.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lpcap.o: ../src/lpeg/lpcap.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"

-include $(OBJECTS:%.o=%.d)
