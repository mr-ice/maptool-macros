[h: speedStr = ""]

[h, if (Walk != ""): speedStr = " / Walk " + Walk]
[h, if (Fly != ""): speedStr = speedStr + " / Fly " + Fly]
[h, if (Climb != ""): speedStr = speedStr + " / Climb " + Climb]
[h, if (Swim != ""): speedStr = speedStr + " / Swim " + Swim]
[h, if (Burrow != ""): speedStr = speedStr + " / Burrow " + Burrow]

[h: speedStr = substring (speedStr, 3)]
[r: macro.return = speedStr]