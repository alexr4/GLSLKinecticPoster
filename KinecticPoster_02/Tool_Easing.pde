static class NormalEasing
{
  // ==================================================
  // Easing Equations by Robert Penner : http://robertpenner.com/easing/
  // http://www.timotheegroleau.com/Flash/experiments/easing_function_generator.htm
  // Based on ActionScript implementation by gizma : http://gizma.com/easing/
  // Processing implementation by Bonjour, Interactive Lab
  // soit time le temps actuel de l'animation normalisé
  // ==================================================
  // Linear
  static float linear(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    float inc = end - start;
    return norm(inc*time/duration + start, 0.0, 1.0);
  }

  // Quadratic
  static float inQuad(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    float inc = end - start;
    return norm(inc * time * time + start, 0.0, 1.0);
  }

  static float outQuad(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    float inc = end - start;
    return norm(-inc * time * (time - 2) + start, 0.0, 1.0);
  }

  static float inoutQuad(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration/2;
    float inc = end - start;
    if (time < 1)
    {
      return norm(inc/2 * time * time + start, 0.0, 1.0);
    } else
    {
      time--;
      return norm(-inc/2 * (time * (time - 2) - 1) + start, 0.0, 1.0);
    }
  }

  //Cubic
  static float inCubic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    float inc = end - start;
    return norm(inc * pow(time, 3) + start, 0.0, 1.0);
  }

  static float outCubic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    time --;
    float inc = end - start;
    return norm(inc * (pow(time, 3) + 1) + start, 0.0, 1.0);
  }

  static float inoutCubic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration/2;
    float inc = end - start;
    if (time < 1)
    {
      return norm(inc/2 * pow(time, 3) + start, 0.0, 1.0);
    } else
    {
      time -= 2;
      return norm(inc/2 * (pow(time, 3) + 2) + start, 0.0, 1.0);
    }
  }

  //Quatric
  static float inQuartic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    float inc = end - start;
    return norm(inc * pow(time, 4) + start, 0.0, 1.0);
  }

  static float outQuartic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    time --;
    float inc = end - start;
    return norm(-inc * (pow(time, 4) - 1) + start, 0.0, 1.0);
  }

  static float inoutQuartic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration/2;
    float inc = end - start;
    if (time < 1)
    {
      return norm(inc/2 * pow(time, 4) + start, 0.0, 1.0);
    } else
    {
      time -= 2;
      return norm(-inc/2 * (pow(time, 4) - 2) + start, 0.0, 1.0);
    }
  }

  //Quintic
  static float inQuintic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    float inc = end - start;
    return norm(inc * pow(time, 5) + start, 0.0, 1.0);
  }

  static float outQuintic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    time --;
    float inc = end - start;
    return norm(inc * (pow(time, 5) + 1) + start, 0.0, 1.0);
  }

  static float inoutQuintic(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration/2;
    float inc = end - start;
    if (time < 1)
    {
      return norm(inc/2 * pow(time, 5) + start, 0.0, 1.0);
    } else
    {
      time -= 2;
      return norm(inc/2 * (pow(time, 5) + 2) + start, 0.0, 1.0);
    }
  }

  //Sinusoïdal
  static float inSin(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    float inc = end - start;
    return norm(-inc * cos(time/duration * HALF_PI) + inc + start, 0.0, 1.0);
  }

  static float outSin(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    float inc = end - start;
    return norm(inc * sin(time/duration * HALF_PI) + start, 0.0, 1.0);
  }

  static float inoutSin(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    float inc = end - start;
    return norm(-inc/2 * (cos(PI * time/duration) - 1) + start, 0.0, 1.0);
  }

  //Exponential
  static float inExp(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    float inc = end - start;
    //return inc * pow(2, 10 * (time/duration - 1)) + start;
    if (time <= 0)
    {
      return start;
    } else
    {
      return norm(inc * pow(2, 10 * (time/duration-1)) + start, 0.0, 1.0);
    }
  }

  static float outExp(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    float inc = end - start;
    if (time >= 1.0)
    {
      return 1.0;
    } else
    {
      return norm(inc * (-pow(2, -10 * (time/duration)) + 1) + start, 0.0, 1.0);
    }
  }

  static float inoutExp(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration/2;
    float inc = end - start;
    if (time < 1)
    {
      return norm(inc/2 * pow(2, 10 * (time-1)) + start, 0.0, 1.0);
    } else
    {
      time --;
      return norm(inc/2 * (-pow(2, -10 * time) + 2) + start, 0.0, 1.0);
    }
  }

  //Circular
  static float inCirc(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    float inc = end - start;
    return norm(-inc * (sqrt(1 - time * time) - 1) + start, 0.0, 1.0);
  }

  static float outCirc(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration;
    time --;
    float inc = end - start;
    return norm(inc * sqrt(1 - time * time) + start, 0.0, 1.0);
  }

  static float inoutCirc(float time)
  { 
    float start = 0.0;
    float end = 1.0;
    float duration = 1.0;
    time /= duration/2;
    float inc = end - start;
    if (time < 1)
    {
      return norm(-inc/2 * (sqrt(1 - time * time) - 1) + start, 0.0, 1.0);
    } else
    {
      time -= 2;
      return norm(inc/2 * (sqrt(1 - time * time) + 1) + start, 0.0, 1.0);
    }
  }

   static float inElastic(float t, float bounceLoop, float bounceForce) {
        return abs((bounceForce * t / (--t) * sin(bounceLoop * t)));
    }

   static float inElastic(float t) {
        return abs((0.05 * t / (--t) * sin(25 * t)));
    }

   static float outElastic(float t, float bounceLoop, float bounceForce) {
        return abs((bounceForce - bounceForce / t) * sin(bounceLoop * t) + 1);
    }

   static float outElastic(float t) {
        return abs((0.05 - 0.05 / t) * sin(25 * t) + 1);
    }

   static float inOutElastic(float t, float bounceLoop, float bounceForce) {
        return (t -= .5) < 0 ? (bounceForce + .01 / t) * sin(bounceLoop * t) : (bounceForce - .01 / t) * sin(bounceLoop * t) + 1;
    }

    static float inOutElastic(float t) {
      return inOutElastic(t, 0.05, 25.0);
    }
}


