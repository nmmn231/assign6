class Bullet{
	int x = -100;
	int y = -100;
	PImage bulletImg;

	Bullet(int x, int y) {
		this.x = x;
		this.y = y;
		bulletImg = loadImage("img/shoot.png");
	}

	void draw()
	{
		image(bulletImg, x, y+15);
	}

	void move()
	{	
		this.x-=1;
		if(this.x < -bulletImg.width){
			bullets[shooting] = null;
		}	
	}
}
