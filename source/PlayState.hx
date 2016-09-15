package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	private var player:FlxSprite;
	private var scoreText:Score;
	private var bullet:FlxSprite;
	private var bulletEnemy:FlxSprite;
	private var escudo:EscudoMaker;
	private var escudo2:EscudoMaker;
	private var escudo3:EscudoMaker;
	private var escudo4:EscudoMaker;
	private var alien:Array<FlxSprite>;
	private var shoot:Bool = false;
	private var shootEnemy:Bool = false;
	private var colicionMuros:Bool = false;
	private var rndEnemy:FlxRandom;
	private var colision = false;
	private var enemyGroup:FlxGroup;
	private var escudoGroup:FlxGroup;
	private var escudoGroup2:FlxGroup;
	private var escudoGroup3:FlxGroup;
	private var escudoGroup4:FlxGroup;
	private var rndEntero:Int;
	private var imagen:Int;
	private var destruido:String;
	private var killCounter:Int = 0;
	
	override public function create():Void
	{
		super.create();
		player = new FlxSprite();
		player.makeGraphic(16, 8);
		player.loadGraphic("assets/img/gif/nave.png");
		player.y = FlxG.height - player.height;
		player.x = 80 - player.width / 2;
		scoreText = new Score();
		escudo = new EscudoMaker(24, 110);
		escudo2 = new EscudoMaker(53, 110);
		escudo3 = new EscudoMaker(82, 110);
		escudo4 = new EscudoMaker(111, 110);
		imagen = 0;
		escudoGroup = escudo.getGroup();
		escudoGroup2 = escudo2.getGroup();
		escudoGroup3 = escudo3.getGroup();
		escudoGroup4 = escudo4.getGroup();
		add(player);
		add(scoreText);
		alien = new Array<FlxSprite>();
		enemyGroup = new FlxGroup();
		rndEnemy = new FlxRandom();
		AlienMaker();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.pressed.LEFT && player.x > 0)
		{
			player.velocity.x = -Reg.velPlayer;
		}
		else if (FlxG.keys.pressed.RIGHT && player.x < FlxG.width-player.width)
		{
			player.velocity.x = Reg.velPlayer;
		}
		else
		{
			player.velocity.x = 0;
		}
		if (FlxG.keys.justPressed.SPACE && shoot == false)
		{
			bullet = new Bullet((player.x + (player.width/2)), (player.y + (player.height/2)),1);
			add(bullet);
			shoot = true;
		}
		if (shootEnemy == false)
		{
			
			rndEntero = rndEnemy.int(0, alien.length - 1 );
			while(shootEnemy == false)
			{
				if(alien[rndEntero].exists)
				{
					trace(rndEntero);
		 			bulletEnemy = new Bullet((alien[rndEntero].x + (alien[rndEntero].width / 2)), (alien[rndEntero].y + (alien[rndEntero].height / 2)), -1);
					add(bulletEnemy);
					shootEnemy = true;    
				}
				else
				{
					trace("REPITE");
					rndEntero = rndEnemy.int(0, alien.length - 1);
				}
			}	
		}
		if (shootEnemy == true)
		{
			if (bulletEnemy.y > 140)
			{
				bulletEnemy.destroy();
				shootEnemy = false;
			}
			else
			{
				for(i in 0...escudoGroup.length)
				{
					if (FlxG.overlap(bulletEnemy, escudoGroup.members[i]))
					{
						destruido = escudo.vida(i);
						trace(destruido);
						if (destruido == "muerto")
						{
							escudoGroup.members[i].destroy();
							escudoGroup.remove(escudoGroup.members[ i]);
						}
						bulletEnemy.destroy();
						shootEnemy = false;
					}
				}
				for(i in 0...escudoGroup2.length)
				{
					if (FlxG.overlap(bulletEnemy, escudoGroup2.members[i]))
					{
						destruido = escudo2.vida(i);
						trace(destruido);
						if (destruido == "muerto")
						{
							escudoGroup2.members[i].destroy();
							escudoGroup2.remove(escudoGroup2.members[ i]);
						}
						bulletEnemy.destroy();
						shootEnemy= false;
					}
				}
				for(i in 0...escudoGroup3.length)
				{
					if (FlxG.overlap(bulletEnemy, escudoGroup3.members[i]))
					{
						destruido = escudo3.vida(i);
						trace(destruido);
						if (destruido == "muerto")
						{
							escudoGroup3.members[i].destroy();
							escudoGroup3.remove(escudoGroup3.members[ i]);
						}
						bulletEnemy.destroy();
						shootEnemy = false;
					}
				}
				for(i in 0...escudoGroup4.length)
				{
					if (FlxG.overlap(bulletEnemy, escudoGroup4.members[i]))
					{
						destruido = escudo4 .vida(i);
						trace(destruido);
						if (destruido == "muerto")
						{
							escudoGroup4.members[i].destroy();
							escudoGroup4.remove(escudoGroup4.members[ i]);
						}
						bulletEnemy.destroy();
						shootEnemy = false;
					}
				}
			}
		}
		if (shoot == true)
		{
			if (bullet.y < 0)
			{
				bullet.destroy();
				shoot = false;
			}
			else
			{
				for (i in 0...enemyGroup.length)
				{
					if (FlxG.overlap(bullet, enemyGroup.members[i]))
					{
						enemyGroup.members[i].kill();
						if (i <= 7) scoreText.addScore(Reg.puntosEnemigo3);
						if (i >= 8 && i <= 23) scoreText.addScore(Reg.puntosEnemigo2);
						if( i >=24 && i <= enemyGroup.length) scoreText.addScore(Reg.puntosEnemigo1);
						killCounter += 1;
						bullet.destroy();
						shoot = false;
						for (i in 0...alien.length)
						{
							if (alien[i].exists)
							{
								if (alien[i].velocity.x < 0)
								{
									alien[i].velocity.x = (5 + (killCounter / 2))*-1;
								}
								else
								{
									alien[i].velocity.x = 5 + (killCounter / 2);
								}
							}
						}
					}
				}
				for(i in 0...escudoGroup.length)
				{
					if (FlxG.overlap(bullet, escudoGroup.members[i]))
					{
						destruido = escudo.vida(i);
						trace(destruido);
						if (destruido == "muerto")
						{
							escudoGroup.members[i].destroy();
							escudoGroup.remove(escudoGroup.members[ i]);
						}
						bullet.destroy();
						shoot = false;
					}
				}
				for(i in 0...escudoGroup2.length)
				{
					if (FlxG.overlap(bullet, escudoGroup2.members[i]))
					{
						destruido = escudo2.vida(i);
						trace(destruido);
						if (destruido == "muerto")
						{
							escudoGroup2.members[i].destroy();
							escudoGroup2.remove(escudoGroup2.members[ i]);
						}
						bullet.destroy();
						shoot = false;
					}
				}
				for(i in 0...escudoGroup3.length)
				{
					if (FlxG.overlap(bullet, escudoGroup3.members[i]))
					{
						destruido = escudo3.vida(i);
						trace(destruido);
						if (destruido == "muerto")
						{
							escudoGroup3.members[i].destroy();
							escudoGroup3.remove(escudoGroup3.members[ i]);
						}
						bullet.destroy();
						shoot = false;
					}
				}
				for(i in 0...escudoGroup4.length )
				{
					if (FlxG.overlap(bullet, escudoGroup4.members[i]))
					{
						destruido = escudo4.vida(i);
						trace(destruido);
						if (destruido == "muerto")
						{
							escudoGroup4.members[i].destroy();
							escudoGroup4 .remove(escudoGroup4.members[ i]);
						}
						bullet.destroy();
						shoot = false;
					}
				}
			}
		}
		// colicion aliens con escudo//
		// --------------------------//
		for (i in 0...alien.length)
		{
			if (alien[i].y > 100)
			{
				for (k in 0...escudoGroup.length)
				{
					if (FlxG.overlap(alien[i], escudoGroup.members[k]))
					{
						escudoGroup.members[k].kill();
						escudoGroup.remove(escudoGroup.members[k]);
					}
				}
				for (k in 0...escudoGroup2.length)
				{
					if (FlxG.overlap(alien[i], escudoGroup2.members[k]))
					{
						escudoGroup2.members[k].kill();
						escudoGroup2.remove(escudoGroup2.members[k]);
					}
				}
				for (k in 0...escudoGroup3.length)
				{
					if (FlxG.overlap(alien[i], escudoGroup3.members[k]))
					{
						escudoGroup3.members[k].kill();
						escudoGroup3.remove(escudoGroup3.members[k]);
					}
				}
				for (k in 0...escudoGroup.length)
				{
					if (FlxG.overlap(alien[i], escudoGroup4.members[k]))
					{
						escudoGroup4.members[k].kill();
						escudoGroup4.remove(escudoGroup4.members[k]);
					}
				}
			}
		}
		
		// --------------------------//
		// fin colicion aliens//
		for (i in 0...alien.length)
		{
			if ((alien[i].x < 0 || alien[i].x > 160 - alien[i].width) && colision == false)
			{
				for (k in 0...alien.length)
				{
					alien[k].y += 8;
					alien[k].velocity.x *= -1;
				}
				colision = true;
			}
		}
		colision = false;
	}
	
	public function AlienMaker()
	{
		for (i in 0...5)
		{
			for (k in 0...8)
			{
				alien.push(new Alien((16 * k) + 20, (8 * i) + 24, i));
				enemyGroup.add(alien[i * 8 + k]);
				add(alien[i*8+k]);
			}
		}
	}
}
