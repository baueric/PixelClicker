color black = color(0);
color white = color(255);
MyPixel[] allPix;

void setup() {
  size(400, 400, P2D);
  colorMode(HSB, 255);
  background(black);
  allPix = new MyPixel[width*height];

  for (int i = 0; i < allPix.length; i++) {
    allPix[i] = new MyPixel(i);
  }
  for (int i = 0; i < allPix.length; i++) {
    allPix[i].init(allPix);
  }

  loadPixels();
}

int lastTime;
int m_x;
int m_y;
boolean onePress = false;

void draw() {

  if (mousePressed) {
    if (!onePress) {
      onePress = true;
      m_x = mouseX;
      m_y = mouseY;

      if (m_x >= width) m_x = width -1;
      else if (m_x < 0) m_x = 0;
      if (m_y >= height) m_y = height - 1; 
      else if (m_y < 0) m_y = 0;

      int pixel = m_y * width + m_x;


      if (allPix[pixel].isBlank()) {
        allPix[pixel].setRandom();
      } else {
        int hue = allPix[pixel].hue;
        for (MyPixel p : allPix) {
          if (p.hue == hue) {
            p.setBlank();
          }
        }
      }
    }
  } else {
    onePress = false;
  }

  // run through each pixel
  for (int i = 0; i < pixels.length; i++) {
    pixels[i] = allPix[i].run();
  }

  updatePixels();
  
  //println(frameRate + "\n");
}

class MyPixel {
  int i;
  int hue;
  int lastHue;
  float saturation;

  color c;

  boolean leftEdge;
  boolean topEdge;
  boolean rightEdge;
  boolean bottomEdge;

  // locations of the pixels around me:
  // Locations in the array:
  //   0  1  2
  //   3  *  7
  //   6  5  4
  MyPixel[] surr = new MyPixel[8];
  // number of surrounding pixels
  int surr_num;

  MyPixel(int index) {
    i = index;
    lastHue = -1;
    hue = -1;
    c = black;
  }

  void setBlank() {
    lastHue = hue;
    hue = -1;
    c = black;
  }

  boolean isBlank() {
    return hue < 0;
  }

  color run() {

    lastHue = hue;

    int newHue = -1;
    float newSat = 0;

    int n = int(random(8));

    if (surr[n] != null) {
      if (n < 4) {
        newHue = surr[n].lastHue;
      } else {
        newHue = surr[n].hue;
      }
      newSat = surr[n].saturation;
    }

    if (newHue >= 0) {
      hue = newHue;
    }

    if (hue != lastHue) {
      int b = (isBlank() ? 0 : (int(random(230,255))));
      saturation = newSat;
      if ( saturation > 60) {
        saturation -= .25;
      }
      c = color(hue, saturation, b);
    }

    return c;
  }

  void setRandom() {
    lastHue = hue;
    hue = int(random(255));
    saturation = 255;
    c = color(hue, 255, 255);
  }

  void init(MyPixel[] all) {

    if (i < width) {
      // on top edge
      topEdge = true;
    }

    if (i % width == 0) {
      // on left edge
      leftEdge = true;
    }

    if (i >= (height - 1) * width) {
      // on bottom edge
      bottomEdge = true;
    }

    if (i % width == width - 1) {
      // on right edge
      rightEdge = true;
    }

    if (!leftEdge && !topEdge) {
      surr[0] = all[i - width - 1];
      surr_num++;
    }
    if (!topEdge) {
      surr[1] = all[i - width];
      surr_num++;
    }
    if (!topEdge && !rightEdge) {
      surr[2] = all[i - width + 1];
      surr_num++;
    }
    if (!rightEdge) {
      surr[7] = all[i + 1];
      surr_num++;
    }
    if (!rightEdge && !bottomEdge) {
      surr[4] = all[i + width + 1];
      surr_num++;
    }
    if (!bottomEdge) {
      surr[5] = all[i + width];
      surr_num++;
    }
    if (!bottomEdge && !leftEdge) {
      surr[6] = all[i + width - 1];
      surr_num++;
    }
    if (!leftEdge) {
      surr[3] = all[i - 1];
      surr_num++;
    }
  }
}
