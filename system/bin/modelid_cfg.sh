#!/sbin/sh
#

# Remove KINETO on incorrect models.
#
# Valid:
# VISION   TMUS MODELID PC1010000
# MAHIMAHI TMUS MODELID PB9910000
# GLACIER  TMUS MODELID PD1510000
# Espresso TMUS MODELID PB6510000
#

kineto=/system/app/MS-HTCEMR-KNT20-02-A0-GB-02.apk
rm_kineto=y

cat /proc/cmdline|egrep -q '(PC1010000)|(PB9910000)|(PD1510000)|(PB6510000)'
if [ $? = 0 ];
    then
       rm_kineto=n
fi

if [ "$rm_kineto" = "y" ];
    then
       if [ -f $kineto ];
          then
             rm -f /system/app/MS-HTCEMR-KNT20-02-A0-GB-02.apk
             rm -f /system/lib/libkineto.so
             rm -f /system/lib/libganril.so
             rm -f /system/lib/librilswitch.so
             sed 's/librilswitch.so/libhtc_ril.so/' /system/build.prop > /tmp/build.tmp
             sed '/rilswitch/d' /tmp/build.tmp > /system/build.prop
             chmod 644 /system/build.prop
             rm /tmp/build*
       fi
fi

#
# Check for spade; if NAM model update DSP and GPS config
#
# NAM Models:
# DHD AT&T  MODELID PD9812000
# DHD TELUS MODELID PD9814000
#

cat /proc/cmdline | grep -q spade
if [ $? = 0 ];
   then 
cat /proc/cmdline | egrep -q '(PD9812000)'
      if [ $? = 0 ];
         then
            cp -R /system/etc/nam/default* /system/etc/firmware/
            cp -R /system/etc/nam/CodecDSPID.txt /system/etc
            cp -R /system/etc/nam/CodecDSPID_MCLK.txt /system/etc
            cp -R /system/etc/nam/*MCLK.txt /system/etc/soundimage/
            cp -R /system/etc/nam/AdieHWCodec.csv /system/etc
            cp -R /system/etc/nam/AIC3254_REG_DualMic_MCLK.csv /system/etc
            cp -R /system/etc/nam/gps.conf /system/etc
            cp -R /system/etc/nam/soundimage/*.txt /system/etc/soundimage
            sed -i 's/ro.product.model.*=.*/ro.product.model=HTC\ Inspire\ 4G/g' /system/build.prop
            /system/bin/snd3254 -dspmode 0
      fi
fi
cat /proc/cmdline | egrep -q '(PD9814000)'
      if [ $? = 0 ];
         then
            cp -R /system/etc/nam/gps.conf /system/etc
            sed -i 's/ro.product.model.*=.*/ro.product.model=HTC\ Telus\ 4G/g' /system/build.prop
            /system/bin/snd3254 -dspmode 0
      fi
fi
rm -R /system/etc/nam
