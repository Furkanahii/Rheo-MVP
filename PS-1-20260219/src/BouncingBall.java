/**
 * Program animates a 2D bouncing ball
 * @author Sedgewick, Wayne
 */

// This implementation is taken from the course's Notion page and edited.
// Visit the Notion page to learn more about the StdDraw library.

public class BouncingBall {
    public static void main(String[] args) {
        int canvasWidth = 1200;
        int canvasHeight = 1600;
        StdDraw.setCanvasSize(canvasWidth, canvasHeight); // Set the size of the drawing canvas
        StdDraw.setXscale(0.0, canvasWidth); // set the scale of the coordinate system
        StdDraw.setYscale(0.0, canvasHeight);
        StdDraw.setTitle("Bouncing Ball");  // Set the title of the animation window
        StdDraw.enableDoubleBuffering(); // Use for faster animations

        int pauseDuration = 95; // pause duration in milliseconds

        double positionX = 400, positionY = 900;  // initial (x,y) ball position
        double velocityX = 20, velocityY = 30;  // initial velocity components
        double radius = 25;  // radius of the ball

        // main animation loop
        while (true)  {
            // bounce off wall according to law of elastic collision
            double nextX = positionX + velocityX;
            double nextY = positionY + velocityY;
            if (nextX > canvasWidth - radius || nextX < radius)
                velocityX = -velocityX;
            if (nextY > canvasHeight - radius || nextY < radius)
                velocityY = -velocityY;

            positionX = positionX + velocityX; // update positions
            positionY = positionY + velocityY;

            StdDraw.clear(StdDraw.WHITE); // clear the background

            //StdDraw.picture(canvasWidth/2.0, canvasHeight/2.0, "assets/field.png", canvasWidth, canvasHeight); // Add a background image
            StdDraw.setPenColor(StdDraw.PRINCETON_ORANGE);                          // sets the pen color for drawing the ball
            StdDraw.filledCircle(positionX, positionY, radius);                     // draw ball on the screen
            //StdDraw.picture(positionX, positionY, "assets/ball.png", 50, 50 );    // use a picture of a football ball
            StdDraw.show();                                                         // show the drawing on the screen
            StdDraw.pause(pauseDuration);                                           // pause the drawing at each iteration
        }
    }
}