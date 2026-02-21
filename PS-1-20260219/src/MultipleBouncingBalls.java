import java.util.Random;
import java.awt.Color;


public class MultipleBouncingBalls {

    static int canvasWidth = 400;
    static int canvasHeight = 600;

    // Update the velocity of the ball if it collides with a wall
    private static int[] updateVelocities(int posX, int posY, int velX, int velY,  double radius){

        // Update the x-component of velocity velX if the ball collides with the left or right wall.
        // Basically it checks the distance between the wall and the ball's center.
        // If the distance is less than the radius, there is a collision.

        int nextX = posX + velX;
        if (nextX > canvasWidth - radius || nextX < radius){
            velX = -velX;
        }

        int nextY = posY + velY;
        // Update the y component of the velocity v_y, if the ball collides with the top or bottom walls
        if (nextY > canvasHeight - radius || nextY < radius)
            velY = -velY;

        int[] vel = {velX, velY};
        return vel;
    }

    public static void main(String[] args) {

        // Set Canvas
        StdDraw.setCanvasSize(400, 600); // set the size of the drawing canvas

        // Setting the max and min scale is extremely important since all the other will be determined based on these values.
        StdDraw.setXscale(0.0, canvasWidth); // set the scale of the coordinate system
        StdDraw.setYscale(0.0, canvasHeight);
        StdDraw.setTitle("Mutliple Bouncing Balls");
        // If you enable double buffering, all drawing takes place on the offscreen canvas and
        // the offscreen canvas is not displayed until calling show()
        StdDraw.enableDoubleBuffering(); // Use for faster animations

        int pauseDuration = 15; // pause duration in milliseconds

        Random random = new Random(); // Creating new Random object

        int N = 20;  // Number of balls


        // Declaring arrays
        int[] ballPosX = new int[N];
        int[] ballPosY = new int[N];
        int[] ballVelX = new int[N];
        int[] ballVelY = new int[N];
        int[] ballRadius = new int[N];
        Color[] ballColors = new Color[N];      // color array for balls

        int minRadius = 5;
        int maxRadius = 10;
        int minVel = 2;
        int maxVel = 10;
        // Randomly initialize the center positions, velocities, colors, and radii of the balls
        for (int i=0; i<N; i++){

            //  Initialize ball radius between 5.0 and 10.0
            ballRadius[i] = (minRadius + random.nextInt(maxRadius - minRadius) );

            // Initialize the center position of the ball with random values between 0 and
            ballPosX[i] = (ballRadius[i] + random.nextInt(canvasWidth - 2 * ballRadius[i]) );
            ballPosY[i] = (ballRadius[i] + random.nextInt(canvasHeight - 2 * ballRadius[i]));

            // Initialize center velocity between minVel and maxVel
            ballVelX[i] = (minVel + random.nextInt(maxVel - minVel) );
            ballVelY[i] = (minVel + random.nextInt(maxVel - minVel) );

            // Initialize color with random RGB values (RGB -> Red Green Blue)
            ballColors[i] = new Color(random.nextInt(255),random.nextInt(255), random.nextInt(255) );


        }

        // Main loop
        while (true){
            // Clear the background otherwise the new objects will be drawn over the previous ones
            StdDraw.clear(StdDraw.WHITE);

            // For each ball, update its velocity and position, and set the pen color to its color
            for(int i=0; i<N; i++){
                int[] updatedVelocities;
                updatedVelocities = updateVelocities(ballPosX[i], ballPosY[i], ballVelX[i], ballVelY[i], ballRadius[i]);
                ballPosX[i] += updatedVelocities[0];
                ballPosY[i] += updatedVelocities[1];
                ballVelX[i] = updatedVelocities[0];
                ballVelY[i] = updatedVelocities[1];
                StdDraw.setPenColor(ballColors[i]);
                StdDraw.filledCircle(ballPosX[i], ballPosY[i], ballRadius[i]);
            }

            // Show the offscreen canvas
            StdDraw.show();

            // Pause 15 milliseconds. Change the value to control blinking and animation speed
            // This method basically calls Thread.sleep(t), which pauses the entire program execution.
            // Check https://introcs.cs.princeton.edu/java/stdlib/StdDraw.java.html
            StdDraw.pause(pauseDuration);
        }
    }
}

