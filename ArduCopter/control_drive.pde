/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-
#include <RC_Channel.h>
#define CH_1 0
#define CH_2 1
#define CH_3 2
#define CH_4 3
#define CH_5 4
#define CH_6 5
#define MAXANGLE 1000
/*
 * control_drive.pde - init and run calls for stabilize flight mode
 */

// drive_init - initialise stabilize controller
extern const AP_HAL::HAL& hal;
    
static bool drive_init(bool ignore_checks)
{
    
    //controle par moteur souhaite et test value
    // Ajout moteur souhaite
    //implementation eventullelemnt a rendre scallable
    
    //IF landed ->true
    if(ap.land_complete){
    return true;
    }else{
    //else -> false
    return false;
    }

}

// drive_run - runs the main stabilize controller
// should be called at 100hz or more
static void drive_run()
{   // input channels
    static RC_Channel *channel_steer; 
    channel_steer = &g.rc_1;
    static RC_Channel *channel_throttle;
    channel_throttle= &g.rc_3;
    //additional input channel for balance
    static RC_Channel *channel_balance;
    channel_balance = &g.rc_6;
    //get input -1 to +1 
    float steering_scaled = channel_steer->norm_input();
    float throttle_scaled = channel_throttle->norm_input();
    float balance_scaled = channel_balance->norm_input();

    // output channels 
    static RC_Channel *channel_R;
    static RC_Channel *channel_L;
/*
// Selects outputsd depending on frame 
// can be extended for any frame 
// LR inverted for test purposes only
#if FRAME_CONFIG == QUAD_FRAME
    channel_R = &g.rc_10;
    channel_L = &g.rc_11;
#elif FRAME_CONFIG == HEX_FRAME
    channel_R = &g.rc_7;
    channel_L = &g.rc_8; 
#else 
    channel_R = &g.rc_5;
    channel_L = &g.rc_6; 
#endif     
*/
    channel_R = &g.rc_10;
    channel_L = &g.rc_11;

    


// if not armed set throttle to zero and exit immediately
    
    if(!motors.armed() ) {
        attitude_control.relax_bf_rate_controller();
        attitude_control.set_yaw_target_to_current_heading();
        attitude_control.set_throttle_out(0, false);
        //STOPS MOTORS 
        channel_R->servo_out = (int16_t)(0);
        channel_L->servo_out = (int16_t)(0);    
        channel_R->calc_pwm();
        channel_L->calc_pwm();
        channel_L->disable_out();
        channel_R->disable_out();
      return;
    }
    //deactivate flight motors
    
    attitude_control.relax_bf_rate_controller();
    attitude_control.set_yaw_target_to_current_heading();
    attitude_control.set_throttle_out(0, false);

    //sets ranges /angle for output // servo_out =  angle*motorX ! 
    //allows using channels as ouput
    channel_R->set_angle((int16_t) MAXANGLE);
    channel_L->set_angle((int16_t) MAXANGLE);

    channel_R->enable_out();
    channel_L->enable_out();   


 
    //calculate power for motors
    float motor1 = throttle_scaled + 0.2f*steering_scaled +0.1f*balance_scaled;
    float motor2 = throttle_scaled - 0.2f*steering_scaled -0.1f*balance_scaled;
    
    //print test value
    //hal.console->printf_P(PSTR(" steer: %f  , throttle %f \n"), steering_scaled , throttle_scaled );    
    //hal.console->printf_P(PSTR(" R: %f  , L %f \n"), motor1 , motor2 );    
    //channel_R->radio_min = 900; // MAGIC NUMBER ...
    channel_R->servo_out = (int16_t)(MAXANGLE*2/3+ (MAXANGLE/3)*motor1);
    channel_L->servo_out = (int16_t)(MAXANGLE*2/3+ (MAXANGLE/3)*motor2);    
    channel_R->calc_pwm();
    channel_L->calc_pwm();
    hal.console->printf_P(PSTR(" L: %i  , R %i \n"), channel_L->radio_out ,channel_R->radio_out );  
    //output 
    channel_R->output();
    channel_L->output();
     
    update_simple_mode(); // Needed to change modes

}


