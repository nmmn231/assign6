class GameState
{
	static final int START = 0;
	static final int PLAYING = 1;
	static final int END = 2;
}
class Direction
{
	static final int LEFT = 0;
	static final int RIGHT = 1;
	static final int UP = 2;
	static final int DOWN = 3;
}
class EnemysShowingType
{
	static final int STRAIGHT = 0;
	static final int SLOPE = 1;
	static final int DIAMOND = 2;
	static final int STRONGLINE = 3;
}
class FlightType
{
	static final int FIGHTER = 0;
	static final int ENEMY = 1;
	static final int ENEMYSTRONG = 2;
}

int state = GameState.START;
int currentType = EnemysShowingType.STRAIGHT;
int enemyCount = 8;
int shooting = 0;
Enemy[] enemys = new Enemy[enemyCount];
Fighter fighter;
Background bg;
FlameMgr flameMgr;
Treasure treasure;
HPDisplay hpDisplay;
Bullet[]bullets = new Bullet[5];

boolean isMovingUp;
boolean isMovingDown;
boolean isMovingLeft;
boolean isMovingRight;

int time;
int wait = 4000;



void setup () {
	size(640, 480);
	flameMgr = new FlameMgr();
	bg = new Background();
	treasure = new Treasure();
	hpDisplay = new HPDisplay();
	fighter = new Fighter(20);
	for (int i = 0; i < 5; ++i) {
		bullets[i]=null;
	}
}

void draw()
{
	if (state == GameState.START) {
		bg.draw();	
	}
	else if (state == GameState.PLAYING) {
		bg.draw();
		treasure.draw();
		flameMgr.draw();
		fighter.draw();

		//enemys
		if(millis() - time >= wait){
			addEnemy(currentType++);
			currentType = currentType%4;
		}		

		for (int i = 0; i < enemyCount; ++i) {
			if (enemys[i]!= null) {
				enemys[i].move();
				enemys[i].draw();
				if (currentType == EnemysShowingType.STRAIGHT){
					if (enemys[i].isCollideWithFighter()) {
						fighter.hpValueChange(-50);
						flameMgr.addFlame(enemys[i].x, enemys[i].y);
						enemys[i]=null;
					}
				}else if (currentType != EnemysShowingType.STRAIGHT){
					if (enemys[i].isCollideWithFighter()) {
						fighter.hpValueChange(-20);
						flameMgr.addFlame(enemys[i].x, enemys[i].y);
						enemys[i]=null;
					}
				}
				else if (enemys[i].isOutOfBorder()) {
					enemys[i]=null;
				}
			}
		}
          hpDisplay.updateWithFighterHP(fighter.hp);

        //bullet
        for (int i = 0; i < 5; i++) {
        	for (int j = 0; j < enemyCount; ++j) {
	        	if(bullets[i] != null){
	        		bullets[i].draw();
	        		bullets[i].move();
	        		if(bullets[i] != null && enemys[j] != null && isHit(bullets[i].x, bullets[i].y, bullets[i].bulletImg.width, bullets[i].bulletImg.height, enemys[j].x, enemys[j].y, enemys[j].enemyImg.width, enemys[j].enemyImg.height)){
						enemys[j].life--;
						bullets[i] = null;
						if(enemys[j].life == 0){
							flameMgr.addFlame(enemys[j].x, enemys[j].y);
							enemys[j]=null;
							bullets[i]=null;
						}
					}	
        		}
        	}
    	}
	}
	else if (state == GameState.END) {
		bg.draw();
		currentType = EnemysShowingType.STRAIGHT;
		for (int i = 0; i < 5; ++i) {
			bullets[i]=null;
		}
	}
}
boolean isHit(int ax, int ay, int aw, int ah, int bx, int by, int bw, int bh)
{
	// Collision x-axis?
    boolean collisionX = (ax + aw >= bx) && (bx + bw >= ax);
    // Collision y-axis?
    boolean collisionY = (ay + ah >= by) && (by + bh >= ay);
    return collisionX && collisionY;
}

void keyPressed(){
  switch(keyCode){
    case UP : isMovingUp = true ;break ;
    case DOWN : isMovingDown = true ; break ;
    case LEFT : isMovingLeft = true ; break ;
    case RIGHT : isMovingRight = true ; break ;
    default :break ;
  }
}
void keyReleased(){
  switch(keyCode){
	case UP : isMovingUp = false ;break ;
    case DOWN : isMovingDown = false ; break ;
    case LEFT : isMovingLeft = false ; break ;
    case RIGHT : isMovingRight = false ; break ;
    default :break ;
  }
  if (key == ' ') {
  	if (state == GameState.PLAYING) {
  		if (bullets[shooting] == null){
			fighter.shoot(shooting);
			shooting++;
			shooting%=5; 
		}
	}
  }
  if (key == ENTER) {
    switch(state) {
      case GameState.START:
      case GameState.END:
        state = GameState.PLAYING;
		enemys = new Enemy[enemyCount];
		flameMgr = new FlameMgr();
		treasure = new Treasure();
		fighter = new Fighter(20);
      default : break ;
    }
  }
}
