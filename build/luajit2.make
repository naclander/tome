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
  OBJDIR     = ../obj/Debug/luajit2
  TARGETDIR  = ../bin/Debug
  TARGET     = $(TARGETDIR)/liblua.a
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
	@echo Running pre-build commands
	../src/luajit2/src/buildvm -m elfasm -o ../src/luajit2/src/lj_vm.s
	../src/luajit2/src/buildvm -m bcdef -o ../src/luajit2/src/lj_bcdef.h ../src/luajit2/src/lib_base.c ../src/luajit2/src/lib_math.c ../src/luajit2/src/lib_bit.c ../src/luajit2/src/lib_string.c ../src/luajit2/src/lib_table.c ../src/luajit2/src/lib_io.c ../src/luajit2/src/lib_os.c ../src/luajit2/src/lib_package.c ../src/luajit2/src/lib_debug.c ../src/luajit2/src/lib_jit.c ../src/luajit2/src/lib_ffi.c
	../src/luajit2/src/buildvm -m ffdef -o ../src/luajit2/src/lj_ffdef.h ../src/luajit2/src/lib_base.c ../src/luajit2/src/lib_math.c ../src/luajit2/src/lib_bit.c ../src/luajit2/src/lib_string.c ../src/luajit2/src/lib_table.c ../src/luajit2/src/lib_io.c ../src/luajit2/src/lib_os.c ../src/luajit2/src/lib_package.c ../src/luajit2/src/lib_debug.c ../src/luajit2/src/lib_jit.c ../src/luajit2/src/lib_ffi.c
	../src/luajit2/src/buildvm -m libdef -o ../src/luajit2/src/lj_libdef.h ../src/luajit2/src/lib_base.c ../src/luajit2/src/lib_math.c ../src/luajit2/src/lib_bit.c ../src/luajit2/src/lib_string.c ../src/luajit2/src/lib_table.c ../src/luajit2/src/lib_io.c ../src/luajit2/src/lib_os.c ../src/luajit2/src/lib_package.c ../src/luajit2/src/lib_debug.c ../src/luajit2/src/lib_jit.c ../src/luajit2/src/lib_ffi.c
	../src/luajit2/src/buildvm -m recdef -o ../src/luajit2/src/lj_recdef.h ../src/luajit2/src/lib_base.c ../src/luajit2/src/lib_math.c ../src/luajit2/src/lib_bit.c ../src/luajit2/src/lib_string.c ../src/luajit2/src/lib_table.c ../src/luajit2/src/lib_io.c ../src/luajit2/src/lib_os.c ../src/luajit2/src/lib_package.c ../src/luajit2/src/lib_debug.c ../src/luajit2/src/lib_jit.c ../src/luajit2/src/lib_ffi.c
	../src/luajit2/src/buildvm -m vmdef -o ../src/luajit2/vmdef.lua ../src/luajit2/src/lib_base.c ../src/luajit2/src/lib_math.c ../src/luajit2/src/lib_bit.c ../src/luajit2/src/lib_string.c ../src/luajit2/src/lib_table.c ../src/luajit2/src/lib_io.c ../src/luajit2/src/lib_os.c ../src/luajit2/src/lib_package.c ../src/luajit2/src/lib_debug.c ../src/luajit2/src/lib_jit.c ../src/luajit2/src/lib_ffi.c
	../src/luajit2/src/buildvm -m folddef -o ../src/luajit2/src/lj_folddef.h ../src/luajit2/src/lj_opt_fold.c
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),release)
  OBJDIR     = ../obj/Release/luajit2
  TARGETDIR  = ../bin/Release
  TARGET     = $(TARGETDIR)/liblua.a
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
	@echo Running pre-build commands
	../src/luajit2/src/buildvm -m elfasm -o ../src/luajit2/src/lj_vm.s
	../src/luajit2/src/buildvm -m bcdef -o ../src/luajit2/src/lj_bcdef.h ../src/luajit2/src/lib_base.c ../src/luajit2/src/lib_math.c ../src/luajit2/src/lib_bit.c ../src/luajit2/src/lib_string.c ../src/luajit2/src/lib_table.c ../src/luajit2/src/lib_io.c ../src/luajit2/src/lib_os.c ../src/luajit2/src/lib_package.c ../src/luajit2/src/lib_debug.c ../src/luajit2/src/lib_jit.c ../src/luajit2/src/lib_ffi.c
	../src/luajit2/src/buildvm -m ffdef -o ../src/luajit2/src/lj_ffdef.h ../src/luajit2/src/lib_base.c ../src/luajit2/src/lib_math.c ../src/luajit2/src/lib_bit.c ../src/luajit2/src/lib_string.c ../src/luajit2/src/lib_table.c ../src/luajit2/src/lib_io.c ../src/luajit2/src/lib_os.c ../src/luajit2/src/lib_package.c ../src/luajit2/src/lib_debug.c ../src/luajit2/src/lib_jit.c ../src/luajit2/src/lib_ffi.c
	../src/luajit2/src/buildvm -m libdef -o ../src/luajit2/src/lj_libdef.h ../src/luajit2/src/lib_base.c ../src/luajit2/src/lib_math.c ../src/luajit2/src/lib_bit.c ../src/luajit2/src/lib_string.c ../src/luajit2/src/lib_table.c ../src/luajit2/src/lib_io.c ../src/luajit2/src/lib_os.c ../src/luajit2/src/lib_package.c ../src/luajit2/src/lib_debug.c ../src/luajit2/src/lib_jit.c ../src/luajit2/src/lib_ffi.c
	../src/luajit2/src/buildvm -m recdef -o ../src/luajit2/src/lj_recdef.h ../src/luajit2/src/lib_base.c ../src/luajit2/src/lib_math.c ../src/luajit2/src/lib_bit.c ../src/luajit2/src/lib_string.c ../src/luajit2/src/lib_table.c ../src/luajit2/src/lib_io.c ../src/luajit2/src/lib_os.c ../src/luajit2/src/lib_package.c ../src/luajit2/src/lib_debug.c ../src/luajit2/src/lib_jit.c ../src/luajit2/src/lib_ffi.c
	../src/luajit2/src/buildvm -m vmdef -o ../src/luajit2/vmdef.lua ../src/luajit2/src/lib_base.c ../src/luajit2/src/lib_math.c ../src/luajit2/src/lib_bit.c ../src/luajit2/src/lib_string.c ../src/luajit2/src/lib_table.c ../src/luajit2/src/lib_io.c ../src/luajit2/src/lib_os.c ../src/luajit2/src/lib_package.c ../src/luajit2/src/lib_debug.c ../src/luajit2/src/lib_jit.c ../src/luajit2/src/lib_ffi.c
	../src/luajit2/src/buildvm -m folddef -o ../src/luajit2/src/lj_folddef.h ../src/luajit2/src/lj_opt_fold.c
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

OBJECTS := \
	$(OBJDIR)/lib_bit.o \
	$(OBJDIR)/lib_os.o \
	$(OBJDIR)/lib_init.o \
	$(OBJDIR)/lj_state.o \
	$(OBJDIR)/lj_lex.o \
	$(OBJDIR)/lj_udata.o \
	$(OBJDIR)/lj_ffrecord.o \
	$(OBJDIR)/lj_load.o \
	$(OBJDIR)/lib_math.o \
	$(OBJDIR)/lib_io.o \
	$(OBJDIR)/lj_crecord.o \
	$(OBJDIR)/lj_str.o \
	$(OBJDIR)/lj_cdata.o \
	$(OBJDIR)/lj_bcwrite.o \
	$(OBJDIR)/lib_base.o \
	$(OBJDIR)/lj_ctype.o \
	$(OBJDIR)/lj_asm.o \
	$(OBJDIR)/lj_ccallback.o \
	$(OBJDIR)/lj_cconv.o \
	$(OBJDIR)/lj_strscan.o \
	$(OBJDIR)/lj_record.o \
	$(OBJDIR)/lj_ccall.o \
	$(OBJDIR)/lj_mcode.o \
	$(OBJDIR)/lj_carith.o \
	$(OBJDIR)/lj_gc.o \
	$(OBJDIR)/lib_aux.o \
	$(OBJDIR)/lj_opt_loop.o \
	$(OBJDIR)/lj_opt_sink.o \
	$(OBJDIR)/lj_ir.o \
	$(OBJDIR)/lib_string.o \
	$(OBJDIR)/lj_opt_mem.o \
	$(OBJDIR)/lj_debug.o \
	$(OBJDIR)/lj_vmevent.o \
	$(OBJDIR)/lj_cparse.o \
	$(OBJDIR)/lj_vmmath.o \
	$(OBJDIR)/lj_trace.o \
	$(OBJDIR)/lib_table.o \
	$(OBJDIR)/lj_api.o \
	$(OBJDIR)/lj_dispatch.o \
	$(OBJDIR)/lj_snap.o \
	$(OBJDIR)/lj_err.o \
	$(OBJDIR)/lj_tab.o \
	$(OBJDIR)/lj_bcread.o \
	$(OBJDIR)/lj_bc.o \
	$(OBJDIR)/lj_lib.o \
	$(OBJDIR)/lj_opt_fold.o \
	$(OBJDIR)/lib_ffi.o \
	$(OBJDIR)/lj_char.o \
	$(OBJDIR)/lj_obj.o \
	$(OBJDIR)/lj_gdbjit.o \
	$(OBJDIR)/lj_func.o \
	$(OBJDIR)/lib_jit.o \
	$(OBJDIR)/lj_parse.o \
	$(OBJDIR)/lib_package.o \
	$(OBJDIR)/lj_opt_dce.o \
	$(OBJDIR)/lib_debug.o \
	$(OBJDIR)/lj_alloc.o \
	$(OBJDIR)/lj_opt_narrow.o \
	$(OBJDIR)/lj_clib.o \
	$(OBJDIR)/lj_meta.o \
	$(OBJDIR)/lj_opt_split.o \
	$(OBJDIR)/lj_vm.o \

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
	@echo Linking luajit2
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
	@echo Cleaning luajit2
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

$(OBJDIR)/lib_bit.o: ../src/luajit2/src/lib_bit.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lib_os.o: ../src/luajit2/src/lib_os.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lib_init.o: ../src/luajit2/src/lib_init.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_state.o: ../src/luajit2/src/lj_state.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_lex.o: ../src/luajit2/src/lj_lex.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_udata.o: ../src/luajit2/src/lj_udata.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_ffrecord.o: ../src/luajit2/src/lj_ffrecord.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_load.o: ../src/luajit2/src/lj_load.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lib_math.o: ../src/luajit2/src/lib_math.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lib_io.o: ../src/luajit2/src/lib_io.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_crecord.o: ../src/luajit2/src/lj_crecord.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_str.o: ../src/luajit2/src/lj_str.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_cdata.o: ../src/luajit2/src/lj_cdata.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_bcwrite.o: ../src/luajit2/src/lj_bcwrite.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lib_base.o: ../src/luajit2/src/lib_base.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_ctype.o: ../src/luajit2/src/lj_ctype.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_asm.o: ../src/luajit2/src/lj_asm.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_ccallback.o: ../src/luajit2/src/lj_ccallback.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_cconv.o: ../src/luajit2/src/lj_cconv.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_strscan.o: ../src/luajit2/src/lj_strscan.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_record.o: ../src/luajit2/src/lj_record.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_ccall.o: ../src/luajit2/src/lj_ccall.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_mcode.o: ../src/luajit2/src/lj_mcode.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_carith.o: ../src/luajit2/src/lj_carith.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_gc.o: ../src/luajit2/src/lj_gc.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lib_aux.o: ../src/luajit2/src/lib_aux.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_opt_loop.o: ../src/luajit2/src/lj_opt_loop.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_opt_sink.o: ../src/luajit2/src/lj_opt_sink.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_ir.o: ../src/luajit2/src/lj_ir.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lib_string.o: ../src/luajit2/src/lib_string.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_opt_mem.o: ../src/luajit2/src/lj_opt_mem.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_debug.o: ../src/luajit2/src/lj_debug.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_vmevent.o: ../src/luajit2/src/lj_vmevent.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_cparse.o: ../src/luajit2/src/lj_cparse.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_vmmath.o: ../src/luajit2/src/lj_vmmath.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_trace.o: ../src/luajit2/src/lj_trace.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lib_table.o: ../src/luajit2/src/lib_table.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_api.o: ../src/luajit2/src/lj_api.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_dispatch.o: ../src/luajit2/src/lj_dispatch.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_snap.o: ../src/luajit2/src/lj_snap.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_err.o: ../src/luajit2/src/lj_err.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_tab.o: ../src/luajit2/src/lj_tab.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_bcread.o: ../src/luajit2/src/lj_bcread.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_bc.o: ../src/luajit2/src/lj_bc.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_lib.o: ../src/luajit2/src/lj_lib.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_opt_fold.o: ../src/luajit2/src/lj_opt_fold.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lib_ffi.o: ../src/luajit2/src/lib_ffi.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_char.o: ../src/luajit2/src/lj_char.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_obj.o: ../src/luajit2/src/lj_obj.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_gdbjit.o: ../src/luajit2/src/lj_gdbjit.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_func.o: ../src/luajit2/src/lj_func.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lib_jit.o: ../src/luajit2/src/lib_jit.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_parse.o: ../src/luajit2/src/lj_parse.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lib_package.o: ../src/luajit2/src/lib_package.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_opt_dce.o: ../src/luajit2/src/lj_opt_dce.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lib_debug.o: ../src/luajit2/src/lib_debug.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_alloc.o: ../src/luajit2/src/lj_alloc.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_opt_narrow.o: ../src/luajit2/src/lj_opt_narrow.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_clib.o: ../src/luajit2/src/lj_clib.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_meta.o: ../src/luajit2/src/lj_meta.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_opt_split.o: ../src/luajit2/src/lj_opt_split.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"
$(OBJDIR)/lj_vm.o: ../src/luajit2/src/lj_vm.s
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -c "$<"

-include $(OBJECTS:%.o=%.d)
