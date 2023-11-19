var hallowTex = Paths.getSparrowAtlas('halloween_bg');

halloweenBG = new FlxSprite(-200, -100);
halloweenBG.frames = hallowTex;
halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
halloweenBG.animation.play('idle');
halloweenBG.antialiasing = true;
add(halloweenBG);

Padre.halloweenLevel = true;
Padre.isHalloween = true;