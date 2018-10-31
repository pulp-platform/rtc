module rtc_top (
                input logic         clk_i,
                input logic         rstn_i,

                input logic         date_update_i,
                input logic [31:0]  date_i,
                output logic [31:0] date_o,

                input logic         clock_update_i,
                output logic [21:0] clock_o,
                input logic [21:0]  clock_i,

                input logic [9:0]   init_sec_cnt_i,

                input logic         calibre_update_i,
                input logic [15:0]  calibre_sec_cnt_i,
                output logic [15:0] calibre_sec_cnt_o,

                input logic         timer_update_i,
                input logic         timer_enable_i,
                input logic         timer_retrig_i,
                input logic [16:0]  timer_target_i,
                output logic [16:0] timer_value_o,

                input logic         alarm_enable_i,
                input logic [5:0]   alarm_mask_i,

                input logic         alarm_update_clock_i,
                input logic [21:0]  alarm_clock_i,
                output logic [21:0] alarm_clock_o,
                input logic         alarm_update_date_i,
                input logic [31:0]  alarm_date_i,
                output logic [31:0] alarm_date_o,

                input logic         event_flag_update_i,
                input logic [1:0]   event_flag_i,
                output logic [1:0]  event_flag_o,

                output logic        event_o
                );

   logic                            s_rtc_update_day;
   logic [31:0]                     s_date;
   assign date_o = s_date;

   rtc_clock i_rtc_clock
     (
      .clk_i                ( clk_i                ),
      .rstn_i               ( rstn_i               ),
      .clock_update_i       ( clock_update_i       ),
      .clock_o              ( clock_o              ),
      .clock_i              ( clock_i              ),
      .init_sec_cnt_i       ( init_sec_cnt_i       ),
      .calibre_update_i     ( calibre_update_i     ),
      .calibre_sec_cnt_i    ( calibre_sec_cnt_i    ),
      .calibre_sec_cnt_o    ( calibre_sec_cnt_o    ),
      .timer_update_i       ( timer_update_i       ),
      .timer_enable_i       ( timer_enable_i       ),
      .timer_retrig_i       ( timer_retrig_i       ),
      .timer_target_i       ( timer_target_i       ),
      .timer_value_o        ( timer_value_o        ),
      .alarm_enable_i       ( alarm_enable_i       ),
      .alarm_mask_i         ( alarm_mask_i         ),
      .alarm_update_clock_i ( alarm_update_clock_i ),
      .alarm_clock_i        ( alarm_clock_i        ),
      .alarm_clock_o        ( alarm_clock_o        ),
      .date_i               ( s_date               ),
      .alarm_update_date_i  ( alarm_update_date_i  ),
      .alarm_date_i         ( alarm_date_i         ),
      .alarm_date_o         ( alarm_date_o         ),

      .event_flag_update_i  ( event_flag_update_i  ),
      .event_flag_i         ( event_flag_i         ),
      .event_flag_o         ( event_flag_o         ),
      .event_o              ( event_o              ),
      .update_day_o         ( s_rtc_update_day     )
      );

   rtc_date i_rtc_date
     (
      .clk_i           ( clk_i            ),
      .rstn_i          ( rstn_i           ),
      .date_update_i   ( date_update_i    ),
      .date_i          ( date_i           ),
      .date_o          ( s_date           ),
      .new_day_i       ( s_rtc_update_day )
      );

endmodule // rtc_top
