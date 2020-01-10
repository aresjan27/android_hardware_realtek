ANDROID_SRC_PATH=../../../
GENERIC_LINUX_PATH=$(ANDROID_SRC_PATH)/build
include $(GENERIC_LINUX_PATH)/MakeConfig

MYDEFS=-DHAVE_SYS_UIO_H -DHAVE_PTHREADS
rm=/bin/rm -f
cp=/bin/cp -f
CC= $(MYCC)
CXX = $(MYCXX)
AR= $(MYAR) cq
RANLIB= $(MYRANLIB)
LIBNAME= $(GENERIC_LINUX_PATH)/lib/libhwse_$(TARGET_BOARD_PLATFORM).so

TOP=$(ANDROID_SRC_PATH)
LOCAL_PATH=.

LOCAL_SRC_FILES:= SeDrv_mmap.c SeLibSaturn.c SeStretchUtils.c SeAPI.c md_mars_mmap.c

LOCAL_C_INCLUDES += $(TOP)/device/realtek/proprietary/libs/rtk_libs/common/include
LOCAL_C_INCLUDES += $(TOP)/device/realtek/proprietary/libs/rtk_libs/common/IPC/include
LOCAL_C_INCLUDES += $(TOP)/device/realtek/proprietary/libs/rtk_libs/common/IPC/generate/include
LOCAL_C_INCLUDES += $(TOP)/device/realtek/proprietary/libs/rtk_libs/common/IPC/generate/include/system
LOCAL_C_INCLUDES += $(TOP)/device/realtek/proprietary/libs/rtk_libs/OSAL/include

OBJ_FILES = $(addsuffix .o, $(basename $(LOCAL_SRC_FILES)))

INCLUDES = $(addprefix -I, $(LOCAL_C_INCLUDES) )

CFLAGS = $(INCLUDES) $(DEFINES) $(LOCAL_CFLAGS) -DSYS_UNIX=1 $(MYDEFS) -fPIC

all: $(LIBNAME)

$(LIBNAME) : $(OBJ_FILES) 
	$(SHOW_COMMAND)$(rm) $@
	$(SHOW_COMMAND)$(AR) $@ $(OBJ_FILES)
	$(SHOW_COMMAND)$(RANLIB) $@
	$(CC) -shared  -o $@ $(OBJ_FILES) -Wl,--no-undefined
clean:
	$(SHOW_COMMAND)$(rm) $(OBJ_FILES) $(LIBNAME) core *~

miniclean: clean

.cpp.o:
	$(rm) -f $@
	$(SHOW_COMMAND)echo -=--=--=- [$*.cpp] -=--=--=--=--=--=--=--=--=-
	$(SHOW_COMMAND)$(CXX) $(CFLAGS) $(WARNING) $(DEBUGFLAG) -c $*.cpp -o $@

.c.o:
	$(rm) -f $@
	$(SHOW_COMMAND)echo --------- [$*.c] ---------------------------
	$(SHOW_COMMAND)$(CC) $(CFLAGS) $(WARNING) $(DEBUGFLAG) -c $*.c -o $@
