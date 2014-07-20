M2DHudView
---
M2DHudView is a simple hud library.
You can show a hud with 3 styles and custom description on the hud.

![](https://raw.githubusercontent.com/0x0c/M2DHudView/master/1.png)
![](https://raw.githubusercontent.com/0x0c/M2DHudView/master/2.png)
![](https://raw.githubusercontent.com/0x0c/M2DHudView/master/3.png)
![](https://raw.githubusercontent.com/0x0c/M2DHudView/master/4.png)

---
You can lock user interaction.

	M2DHudView *hud = ...;
	[hud lockUserInteraction];
---
Each hud is assigned unique identifier.
You can dismiss hud with its identifier like this.

	[M2DHudView dismissWithIdentifier:identifier]