M2DHudView
===
M2DHudView is a simple hud library.
You can show a hud with 3 styles and custom description on the hud.

![](https://raw.githubusercontent.com/0x0c/M2DHudView/master/1.png)
![](https://raw.githubusercontent.com/0x0c/M2DHudView/master/2.png)
![](https://raw.githubusercontent.com/0x0c/M2DHudView/master/3.png)
![](https://raw.githubusercontent.com/0x0c/M2DHudView/master/4.png)

Requirements
====

- Runs on iOS 4.0 or later.
- Must be complied with ARC.

Usage
====
---
Easy to use like this.

	M2DHudView *hud = [[M2DHudView alloc] initWithStyle:M2DHudViewStyleSuccess title:nil];
	[hud showWithDuration:3];

---
5 animations are already implemented.
These are performed in start(show) or end(dismiss) timing.

	M2DHudViewTransitionStartZoomOut,
	M2DHudViewTransitionStartFadeIn,
	M2DHudViewTransitionEndZoomIn,
	M2DHudViewTransitionEndZoomOut,
	M2DHudViewTransitionEndFadeOut

---
You can lock user interaction.

	M2DHudView *hud = ...;
	[hud lockUserInteraction];
---
Each hud is assigned unique identifier.
You can dismiss hud with its identifier like this.

	[M2DHudView dismissWithIdentifier:identifier]

---

Please check some features in header file.

Contacts
====

- [akira.matsuda@me.com](mailto:akira.matsuda@me.com)

License
====

M2DHudView is available under the MIT license.