/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-
#define DRIVE   17
#ifdef USERHOOK_INIT
void userhook_init()
{
    // put your initialisation code here
    // this will be called once at start-up
}
#endif

#ifdef USERHOOK_FASTLOOP
void userhook_FastLoop()
{
    // put your 100Hz code here
}
#endif

#ifdef USERHOOK_50HZLOOP
void userhook_50Hz()
{
    // put your 50Hz code here
}
#endif

#ifdef USERHOOK_MEDIUMLOOP
void userhook_MediumLoop()
{
    // put your 10Hz code here
}
#endif

#ifdef USERHOOK_SLOWLOOP
void userhook_SlowLoop()
{
    // put your 3.3Hz code here
}
#endif

#ifdef USERHOOK_SUPERSLOWLOOP
void userhook_SuperSlowLoop()
{
    // put your 1Hz code here
    //disactivate channels when not in use 

    if((control_mode!=DRIVE) && (g.rc_10.servo_out != 0 )){
/*
#if FRAME_CONFIG == QUAD_FRAME 
    g.rc_5.disable_out();
    g.rc_6.disable_out();

#elif FRAME_CONFIG == HEX_FRAME 

    g.rc_7.disable_out();
    g.rc_8.disable_out();

#else 
    g.rc_5.disable_out();
    g.rc_6.disable_out();
#endif
*/  g.rc_10.servo_out = (int16_t)(0);
    g.rc_11.servo_out = (int16_t)(0);
    g.rc_10.calc_pwm();
    g.rc_11.calc_pwm();
    g.rc_10.output();
    g.rc_11.output();
    g.rc_10.disable_out();
    g.rc_11.disable_out();

    }
}
#endif
