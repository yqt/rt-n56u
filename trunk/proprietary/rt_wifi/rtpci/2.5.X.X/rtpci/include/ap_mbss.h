/*
 ***************************************************************************
 * Ralink Tech Inc.
 * 4F, No. 2 Technology 5th Rd.
 * Science-based Industrial Park
 * Hsin-chu, Taiwan, R.O.C.
 *
 * (c) Copyright 2002, Ralink Technology, Inc.
 *
 * All rights reserved. Ralink's source code is an unpublished work and the
 * use of a copyright notice does not imply otherwise. This source code
 * contains confidential trade secret material of Ralink Tech. Any attemp
 * or participation in deciphering, decoding, reverse engineering or in any
 * way altering the source code is stricitly prohibited, unless the prior
 * written consent of Ralink Technology, Inc. is obtained.
 ***************************************************************************

    Module Name:
    ap_mbss.h

    Abstract:
    Support multi-BSS function.

    Revision History:
    Who         When            What
    --------    ----------      ----------------------------------------------
    Sample Lin  01-02-2007      created
*/

#ifndef MODULE_MBSS

#define MBSS_EXTERN    extern

#else

#define MBSS_EXTERN

#endif // MODULE_MBSS //


/*
	For MBSS, the phy mode is different;
	So MBSS_PHY_MODE_RESET() can help us to adjust the correct mode &
	maximum MCS for the BSS.
*/
#define MBSS_PHY_MODE_RESET(__BssId, __HtPhyMode)				\
	{															\
		UCHAR __PhyMode = pAd->ApCfg.MBSSID[__BssId].PhyMode;	\
		if ((__PhyMode == PHY_11B) &&							\
			(__HtPhyMode.field.MODE != MODE_CCK))				\
		{														\
			__HtPhyMode.field.MODE = MODE_CCK;					\
			__HtPhyMode.field.MCS = 3;							\
		}														\
		else if ((__PhyMode < PHY_11ABGN_MIXED) &&				\
				(__PhyMode != PHY_11B) &&						\
				(__HtPhyMode.field.MODE != MODE_OFDM))			\
		{														\
			__HtPhyMode.field.MODE = MODE_OFDM;					\
			__HtPhyMode.field.MCS = 7;							\
		}														\
	}

/* Public function list */
MBSS_EXTERN VOID RT28xx_MBSS_Init(
	IN PRTMP_ADAPTER ad_p,
	IN PNET_DEV main_dev_p);

MBSS_EXTERN VOID RT28xx_MBSS_Close(
	IN PRTMP_ADAPTER ad_p);

MBSS_EXTERN VOID RT28xx_MBSS_Remove(
	IN PRTMP_ADAPTER ad_p);

INT MBSS_VirtualIF_Open(
	IN	PNET_DEV			dev_p);
INT MBSS_VirtualIF_Close(
	IN	PNET_DEV			dev_p);
INT MBSS_VirtualIF_PacketSend(
	IN PNDIS_PACKET			skb_p,
	IN PNET_DEV				dev_p);
INT MBSS_VirtualIF_Ioctl(
	IN PNET_DEV				dev_p, 
	IN OUT struct ifreq 	*rq_p, 
	IN INT cmd);
INT	Show_MbssInfo_Display_Proc(
	IN	PRTMP_ADAPTER	pAd,
	IN	PSTRING			arg);

/* End of ap_mbss.h */
