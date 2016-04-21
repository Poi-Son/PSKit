//
//  PSLayout.h
//  PSKit
//
//  Created by PoiSon on 15/12/9.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <PSKit/PSViewLayout.h>
#import <PSKit/PSLayerLayout.h>

/* How to use PSLayout.
 * eg.
 * [PSLayoutV(view).withSize(10, 10).toLeft(relatedView).distance(10).and.toBottomV.distance(30) apply];
 *          ┌───────┐
 *          │       │relatedView
 *          │       │
 *          │       │
 *   ─ ┬ ─ ─└───────┘
 *     │    │
 *   　30
 *     │    │
 *  ┬┌─┴─┐10
 * 10│   ├──┤
 *  ┴└───┘view
 * =================================================================================================
 * [PSLayoutV(view).withSize(10, 10).toRight(relatedView).distance(30).and.alignBottomV apply];
 *            ┌─────────┐
 * relatedView│         │
 *            │         │          ├10 ┤
 *            │         │          ┌───┐
 *            │         ├─── 30 ───┤   │
 *            └─────────┴─ ─ ─ ─ ─ ┴───┘view
 * =================================================================================================
 * [PSLayoutV(view).withSize(10, 10).alignParentLeft.distance(10).and.alignParentBottom.distance(30) apply];
 * ┌───────────────────────────┐
 * │              superview    │
 * │                           │
 * │                           │
 * │                           │
 * │  ├10 ┤view                │
 * │10┌───┐┬                   │
 * ├──┤   │10                  │
 * │  └─┬─┘┴                   │
 * │    │                      │
 * │  　30       　　           │
 * │    │                      │
 * └────┴──────────────────────┘
 * =================================================================================================
 * [PSLayoutV(view).withSize(10, 10).toParentBottom.and.alignParentCenterWidth apply];
 * ┌───────────────────────────┐
 * │              superview    │
 * │                           │
 * │                           │
 * │                           │
 * │                           │
 * │                           │
 * │                           │
 * │                           │
 * └───────────┬───┬───────────┘
 * ├ ─ ─ ─ ─ ─ ┤   ├ ─ ─ ─ ─ ─ ┤
 *             └───┘view
 * =================================================================================================
 * [PSLayoutV(view).withSize(10, 10).alignParentLeft.distance(50).and.toBottom(relatedView).distance(10) apply];
 * ┌───────────────────────────┐
 * ├───────┐relatedView        │
 * │       │                   │
 * │       │                   │
 * │       │                   │
 * ├───────┘─ ─ ─ ┬ ─          │
 * │        　    10   　　     │
 * │            ┌─┴─┐          │
 * ├──── 50 ────┤   │view      │
 * │            └───┘          │
 * │ superview                 │
 * └───────────────────────────┘
 */