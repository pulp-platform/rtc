module rtc_clock (
                  input logic         clk_i,
                  input logic         rstn_i,

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

                  input logic [31:0]  date_i,

                  input logic         event_flag_update_i,
                  input logic [1:0]   event_flag_i ,
                  output logic [1:0]  event_flag_o,
                  output logic        event_o,

                  output logic        update_day_o
                  );

   logic [7:0]                        r_seconds;
   logic [7:0]                        r_minutes;
   logic [5:0]                        r_hours;

   logic [7:0]                        s_seconds;
   logic [7:0]                        s_minutes;
   logic [5:0]                        s_hours;

   logic [7:0]                        r_alarm_seconds;
   logic [7:0]                        r_alarm_minutes;
   logic [5:0]                        r_alarm_hours;
   logic [13:0]                       r_alarm_year;
   logic [4:0]                        r_alarm_month;
   logic [5:0]                        r_alarm_day;

   logic [5:0]                        r_alarm_mask;
   logic                              r_alarm_enable;

   logic [7:0]                        s_alarm_seconds;
   logic [7:0]                        s_alarm_minutes;
   logic [5:0]                        s_alarm_hours;

   logic [13:0]                       s_alarm_year;
   logic [4:0]                        s_alarm_month;
   logic [5:0]                        s_alarm_day;

   logic [13:0]                       s_year;
   logic [4:0]                        s_month;
   logic [5:0]                        s_day;

   logic [15:0]                       r_sec_counter;
   logic [15:0]                       r_sec_cnt_calibre;

   logic                              s_update_seconds;
   logic                              s_update_minutes;
   logic                              s_update_hours;
   logic                              s_alarm_match;
   logic                              r_alarm_match;
   logic                              s_alarm_event;
   logic                              s_timer_event;

   logic                              s_match_year;
   logic                              s_match_month;
   logic                              s_match_day;
   logic                              s_match_hours;
   logic                              s_match_minutes;
   logic                              s_match_seconds;

   logic [16:0]                       r_timer;
   logic [16:0]                       r_timer_target;
   logic                              r_timer_en;
   logic                              r_timer_retrig;

   logic [1:0]                        r_event_flag;

   assign s_seconds = clock_i[7:0];
   assign s_minutes = clock_i[15:8];
   assign s_hours   = clock_i[21:16];

   assign s_day    = date_i[5:0];
   assign s_month  = date_i[12:8];
   assign s_year   = date_i[29:16];

   assign s_alarm_seconds = alarm_clock_i[7:0];
   assign s_alarm_minutes = alarm_clock_i[15:8];
   assign s_alarm_hours   = alarm_clock_i[21:16];

   assign s_alarm_day   = alarm_date_i[5:0];
   assign s_alarm_month = alarm_date_i[12:8];
   assign s_alarm_year  = alarm_date_i[29:16];

   assign s_match_year    = r_alarm_mask[5] | ( s_year    == r_alarm_year );
   assign s_match_month   = r_alarm_mask[4] | ( s_month   == r_alarm_month );
   assign s_match_day     = r_alarm_mask[3] | ( s_day     == r_alarm_day );
   assign s_match_hours   = r_alarm_mask[2] | ( r_hours   == r_alarm_hours );
   assign s_match_minutes = r_alarm_mask[1] | ( r_minutes == r_alarm_minutes );
   assign s_match_seconds = r_alarm_mask[0] | ( r_seconds == r_alarm_seconds );

   assign s_alarm_match = s_match_year & s_match_month & s_match_day &
                          s_match_hours & s_match_minutes & s_match_seconds;

   assign s_alarm_event = r_alarm_enable & s_alarm_match & ~r_alarm_match; //edge detect on alarm event

   assign s_timer_match = r_timer == r_timer_target;
   assign s_timer_event = r_timer_en & s_timer_match;

   assign s_update_seconds = (r_sec_counter == r_sec_cnt_calibre);
   assign s_update_minutes = s_update_seconds & (r_seconds == 8'h59);
   assign s_update_hours   = s_update_minutes & (r_minutes == 8'h59);

   assign event_o        = s_alarm_event | s_timer_event;
   assign update_day_o   = s_update_hours & (r_hours == 6'h23);
   assign clock_o        = {r_hours,r_minutes,r_seconds};
   assign alarm_clock_o  = {r_alarm_hours,r_alarm_minutes,r_alarm_seconds};
   assign alarm_date_o   = {2'b00,r_alarm_year,3'b000,r_alarm_month,2'b00,r_alarm_day};

   assign timer_value_o     = r_timer;
   assign calibre_sec_cnt_o = r_sec_cnt_calibre;
   assign event_flag_o      = r_event_flag;


   always @ (posedge clk_i or negedge rstn_i)
     begin
        if(~rstn_i)
          r_event_flag <= 'h0;
        else
          begin
             if (event_flag_update_i)
               begin
                  if (event_flag_i[0])
                    r_event_flag[0] <= 1'b0;

                  if (event_flag_i[1])
                    r_event_flag[1] <= 1'b0;
               end // if (event_flag_update_i)
             else if (s_alarm_event)
               begin
                  r_event_flag[0] <= 1'b1;
               end
             else if (s_timer_event)
               begin
                  r_event_flag[1] <= 1'b1;
               end
          end
     end

   always @ (posedge clk_i or negedge rstn_i)
     begin
        if(~rstn_i)
          begin
             r_alarm_seconds <= 'h0;
             r_alarm_minutes <= 'h0;
             r_alarm_hours   <= 'h0;
             r_alarm_enable  <= 'h0;
             r_alarm_mask    <= 'h0;
             r_alarm_year    <= 'h0;
             r_alarm_month   <= 'h0;
             r_alarm_day     <= 'h0;
          end
        else
          begin
             if (alarm_update_clock_i)
               begin
                  r_alarm_enable  <= alarm_enable_i;
                  r_alarm_seconds <= s_alarm_seconds;
                  r_alarm_minutes <= s_alarm_minutes;
                  r_alarm_hours   <= s_alarm_hours  ;
                  r_alarm_mask    <= alarm_mask_i;
               end
             else if(s_alarm_event) //disable alarm when alarm event is generated(sw must retrigger)
               r_alarm_enable <= 'h0;
             if (alarm_update_date_i)
               begin
                  r_alarm_year    <= s_alarm_year;
                  r_alarm_month   <= s_alarm_month;
                  r_alarm_day     <= s_alarm_day;
               end
          end
     end

   always @ (posedge clk_i or negedge rstn_i)
     begin
        if(~rstn_i)
          r_alarm_match <= 'h0;
        else
          r_alarm_match <= s_alarm_match;
     end

   always @ (posedge clk_i or negedge rstn_i)
     begin
        if(~rstn_i)
          begin
             r_timer_en     <= 'h0;
             r_timer_target <= 'h0;
             r_timer        <= 'h0;
             r_timer_retrig <= 'h0;
          end
        else
          begin
             if (timer_update_i)
               begin
                  r_timer_en     <= timer_enable_i;
                  r_timer_target <= timer_target_i;
                  r_timer_retrig <= timer_retrig_i;
                  r_timer        <= 'h0;
               end
             else if(r_timer_en)
               begin
                  if(s_timer_match)
                    begin
                       if(!r_timer_retrig)
                         r_timer_en <= 0;
                       r_timer    <= 'h0;
                    end
                  else
                    r_timer <= r_timer + 1;
               end
          end
     end

   always @ (posedge clk_i or negedge rstn_i)
     begin
        if(~rstn_i)
          r_sec_cnt_calibre <= 'h7FFF;
        else
          begin
             if (calibre_update_i)
               r_sec_cnt_calibre <= calibre_sec_cnt_i;
          end
     end

   always @ (posedge clk_i or negedge rstn_i)
     begin
        if(~rstn_i)
          r_sec_counter <= 'h0;
        else
          begin
             if (clock_update_i)
               r_sec_counter <= {1'b0, init_sec_cnt_i, 5'h0};
             else
               begin
                  if (s_update_seconds)
                    r_sec_counter <= 'h0;
                  else
                    r_sec_counter <= r_sec_counter + 1;
               end
          end
     end

   always @(posedge clk_i or negedge rstn_i)
     begin
        if(~rstn_i)
          begin
             r_seconds <= 0;
             r_minutes <= 0;
             r_hours   <= 0;
          end
        else
          begin
             if (clock_update_i)
               begin
                  r_seconds <= s_seconds;
                  r_minutes <= s_minutes;
                  r_hours   <= s_hours;
               end
             else
               begin
                  if (s_update_seconds)
                    begin // advance the seconds
                       if (r_seconds[3:0] >= 4'h9)
                         r_seconds[3:0] <= 4'h0;
                       else
                         r_seconds[3:0] <= r_seconds[3:0] + 4'h1;
                       if (r_seconds >= 8'h59)
                         r_seconds[7:4] <= 4'h0;
                       else if (r_seconds[3:0] >= 4'h9)
                         r_seconds[7:4] <= r_seconds[7:4] + 4'h1;
                    end

                  if (s_update_minutes)
                    begin // advance the minutes
                       if (r_minutes[3:0] >= 4'h9)
                         r_minutes[3:0] <= 4'h0;
                       else
                         r_minutes[3:0] <= r_minutes[3:0] + 4'h1;
                       if (r_minutes >= 8'h59)
                         r_minutes[7:4] <= 4'h0;
                       else if (r_minutes[3:0] >= 4'h9)
                         r_minutes[7:4] <= r_minutes[7:4] + 4'h1;
                    end

                  if (s_update_hours)
                    begin // advance the hours
                       if (r_hours >= 6'h23)
                         begin
                            r_hours <= 6'h00;
                         end else if (r_hours[3:0] >= 4'h9)
                           begin
                              r_hours[3:0] <= 4'h0;
                              r_hours[5:4] <= r_hours[5:4] + 2'h1;
                           end else begin
                              r_hours[3:0] <= r_hours[3:0] + 4'h1;
                           end
                    end
               end
          end
     end


endmodule
