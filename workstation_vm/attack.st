FUNCTION_BLOCK scale_to_signed
  VAR_INPUT
    input_uint : UINT;
  END_VAR
  VAR_OUTPUT
    output_int : INT;
  END_VAR
  VAR
    _TMP_DIV3_OUT : UINT;
    _TMP_ABS8_OUT : UINT;
    _TMP_UINT_TO_INT9_OUT : INT;
  END_VAR

  _TMP_DIV3_OUT := DIV(input_uint, 2);
  _TMP_ABS8_OUT := ABS(_TMP_DIV3_OUT);
  _TMP_UINT_TO_INT9_OUT := UINT_TO_INT(_TMP_ABS8_OUT);
  output_int := _TMP_UINT_TO_INT9_OUT;
END_FUNCTION_BLOCK

PROGRAM main
  VAR
    flow_set AT %MW100 : UINT := 0;
    a_setpoint AT %MW101 : UINT := 65535;
    pressure_sp AT %MW102 : UINT := 65535;
    override_sp AT %MW103 : UINT := 65535;
    level_sp AT %MW104 : UINT := 65535;
  END_VAR
  VAR
    scale_to_signed0 : scale_to_signed;
  END_VAR
  VAR
    f1_valve_pos AT %IW100 : UINT := 30000;
    f1_flow AT %IW101 : UINT := 30000;
    f2_valve_pos AT %IW102 : UINT := 30000;
    f2_flow AT %IW103 : UINT := 30000;
    purge_valve_pos AT %IW104 : UINT := 30000;
    purge_flow AT %IW105 : UINT := 30000;
    product_valve_pos AT %IW106 : UINT := 30000;
    product_flow AT %IW107 : UINT := 10000;
    pressure AT %IW108 : UINT := 60000;
    level AT %IW109 : UINT := 30000;
    a_in_purge AT %IW110 : UINT := 30000;
    b_in_purge AT %IW111 : UINT := 10000;
    c_in_purge AT %IW112 : UINT := 10000;
    f1_valve_sp AT %QW100 : UINT := 65535;
    f2_valve_sp AT %QW101 : UINT := 65535;
    purge_valve_sp AT %QW102 : UINT := 0;
    product_valve_sp AT %QW103 : UINT := 0;
  END_VAR
  VAR
    product_valve_safe : UINT := 0;
    purge_valve_safe : UINT := 65535;
    f1_valve_safe : UINT := 0;
    f2_valve_safe : UINT := 0;
  END_VAR
  VAR
    hmi_pressure AT %MW120 : INT;
    hmi_level AT %MW121 : INT;
    hmi_f1_valve_pos AT %MW122 : INT;
    hmi_f1_flow AT %MW123 : INT;
    hmi_f2_valve_pos AT %MW124 : INT;
    hmi_f2_flow AT %MW125 : INT;
    hmi_purge_valve_pos AT %MW126 : INT;
    hmi_purge_flow AT %MW127 : INT;
    hmi_product_valve_pos AT %MW128 : INT;
    hmi_product_flow AT %MW129 : INT;
    scan_count AT %MW130 : UINT := 0;
  END_VAR
  VAR
    scale_to_signed1 : scale_to_signed;
    scale_to_signed2 : scale_to_signed;
    scale_to_signed3 : scale_to_signed;
    scale_to_signed4 : scale_to_signed;
    scale_to_signed5 : scale_to_signed;
    scale_to_signed6 : scale_to_signed;
    scale_to_signed7 : scale_to_signed;
    scale_to_signed8 : scale_to_signed;
    scale_to_signed9 : scale_to_signed;
  END_VAR
  VAR_EXTERNAL
    run_bit : BOOL;
  END_VAR
  VAR
    _TMP_ADD87_OUT : UINT;
    _TMP_GE91_OUT : BOOL;
    _TMP_MOVE92_ENO : BOOL;
    _TMP_MOVE92_OUT : UINT;
  END_VAR

  scale_to_signed0(input_uint := 30000);
  hmi_pressure := scale_to_signed0.output_int;
  scale_to_signed1(input_uint := 16000);
  hmi_level := scale_to_signed1.output_int;
  scale_to_signed2(input_uint := 10000);
  hmi_f1_valve_pos := scale_to_signed2.output_int;
  scale_to_signed3(input_uint := 10000);
  hmi_f2_valve_pos := scale_to_signed3.output_int;
  scale_to_signed4(input_uint := 3000);
  hmi_purge_valve_pos := scale_to_signed4.output_int;
  scale_to_signed5(input_uint := 15000);
  hmi_product_valve_pos := scale_to_signed5.output_int;
  scale_to_signed6(input_uint := 10000);
  hmi_f1_flow := scale_to_signed6.output_int;
  scale_to_signed7(input_uint := 10000);
  hmi_f2_flow := scale_to_signed7.output_int;
  scale_to_signed8(input_uint := 3000);
  hmi_purge_flow := scale_to_signed8.output_int;
  scale_to_signed9(input_uint := 15000);
  hmi_product_flow := scale_to_signed9.output_int;
  _TMP_ADD87_OUT := ADD(scan_count, 1);
  scan_count := _TMP_ADD87_OUT;
  _TMP_GE91_OUT := GE(scan_count, 32000);
  _TMP_MOVE92_OUT := MOVE(EN := _TMP_GE91_OUT, IN := 0, ENO => _TMP_MOVE92_ENO);
  IF _TMP_MOVE92_ENO THEN
      scan_count := _TMP_MOVE92_OUT;
  END_IF;
END_PROGRAM

FUNCTION_BLOCK scale_to_real
  VAR_INPUT
    raw_input_value : UINT;
  END_VAR
  VAR_OUTPUT
    scaled_real : REAL;
  END_VAR
  VAR_INPUT
    real_max : REAL;
    real_min : REAL;
  END_VAR
  VAR
    raw_max : UINT := 65535;
    raw_min : UINT := 0;
    rate : REAL;
    offset : REAL;
  END_VAR

  rate := (real_max - real_min) / UINT_TO_REAL(raw_max - raw_min);
  offset := real_min - UINT_TO_REAL(raw_min)*rate;
  scaled_real := UINT_TO_REAL(raw_input_value)*rate + offset;
END_FUNCTION_BLOCK

FUNCTION_BLOCK scale_to_uint
  VAR_INPUT
    real_in : REAL;
  END_VAR
  VAR_OUTPUT
    uint_out : UINT;
  END_VAR
  VAR
    _TMP_DIV1_OUT : REAL;
    _TMP_MUL4_OUT : REAL;
    _TMP_REAL_TO_UINT6_OUT : UINT;
  END_VAR

  _TMP_DIV1_OUT := DIV(real_in, 100.0);
  _TMP_MUL4_OUT := MUL(_TMP_DIV1_OUT, 65535.0);
  _TMP_REAL_TO_UINT6_OUT := REAL_TO_UINT(_TMP_MUL4_OUT);
  uint_out := _TMP_REAL_TO_UINT6_OUT;
END_FUNCTION_BLOCK

FUNCTION_BLOCK pressure_control
  VAR
    pressure_real : REAL := 2700.0;
  END_VAR
  VAR_INPUT
    pressure : UINT := 58981;
  END_VAR
  VAR
    pressure_sp_real : REAL := 2700.0;
  END_VAR
  VAR_INPUT
    pressure_sp : UINT := 58981;
    curr_pos : UINT := 30000;
  END_VAR
  VAR
    valve_pos_real : REAL := 39.25;
    pos_update_real : REAL := 0.0;
    valve_pos_nominal : REAL := 39.25;
  END_VAR
  VAR_OUTPUT
    valve_pos : UINT := 25886;
  END_VAR
  VAR
    pressure_k : REAL := -2.0;
    pressure_ti : REAL := 999.0;
    cycle_time : TIME := T#200ms;
    PID0 : PID;
    scale_to_real5 : scale_to_real;
    scale_to_real4 : scale_to_real;
    scale_to_uint0 : scale_to_uint;
    pressure_max : REAL := 3000.0;
    pressure_min : REAL := 0.0;
    pos_min : REAL := 0.0;
    pos_max : REAL := 100.0;
    scale_to_real0 : scale_to_real;
    _TMP_SUB53_OUT : REAL;
    _TMP_LIMIT55_OUT : REAL;
  END_VAR

  PID0(AUTO := TRUE, PV := pressure_real, SP := pressure_sp_real, X0 := valve_pos_nominal, KP := pressure_k, TR := pressure_ti, CYCLE := cycle_time);
  pos_update_real := PID0.XOUT;
  scale_to_real5(raw_input_value := pressure, real_max := pressure_max, real_min := pressure_min);
  pressure_real := scale_to_real5.scaled_real;
  scale_to_real4(raw_input_value := pressure_sp, real_max := pressure_max, real_min := pressure_min);
  pressure_sp_real := scale_to_real4.scaled_real;
  _TMP_SUB53_OUT := SUB(valve_pos_real, pos_update_real);
  _TMP_LIMIT55_OUT := LIMIT(pos_min, _TMP_SUB53_OUT, pos_max);
  scale_to_uint0(real_in := _TMP_LIMIT55_OUT);
  valve_pos := scale_to_uint0.uint_out;
  scale_to_real0(raw_input_value := curr_pos, real_max := pos_max, real_min := pos_min);
  valve_pos_real := scale_to_real0.scaled_real;
END_FUNCTION_BLOCK

FUNCTION_BLOCK flow_control
  VAR
    flow_k : REAL := 2.0;
    flow_ti : REAL := 999.0;
    flow_td : REAL := 0.0;
  END_VAR
  VAR_INPUT
    product_flow : UINT := 6554;
  END_VAR
  VAR
    product_flow_real : REAL := 100.0;
    cycle_time : TIME := T#200ms;
    pos_update_real : REAL := 0.0;
    curr_pos_real : REAL := 60.9;
  END_VAR
  VAR_OUTPUT
    new_pos : UINT := 35000;
  END_VAR
  VAR_INPUT
    curr_pos : UINT := 35000;
  END_VAR
  VAR
    flow_set_real : REAL := 100.0;
  END_VAR
  VAR_INPUT
    flow_set_in : UINT := 6554;
  END_VAR
  VAR
    scale_to_real0 : scale_to_real;
    scale_to_real1 : scale_to_real;
    flow_max : REAL := 500.0;
    flow_min : REAL := 0.0;
    pos_min : REAL := 0.0;
    pos_max : REAL := 100.0;
    scale_to_real2 : scale_to_real;
    scale_to_uint0 : scale_to_uint;
    PID0 : PID;
    _TMP_SUB58_OUT : REAL;
    _TMP_LIMIT40_OUT : REAL;
  END_VAR

  PID0(AUTO := TRUE, PV := product_flow_real, SP := flow_set_real, KP := flow_k, TR := flow_ti, TD := flow_td, CYCLE := cycle_time);
  pos_update_real := PID0.XOUT;
  scale_to_real0(raw_input_value := product_flow, real_max := flow_max, real_min := flow_min);
  product_flow_real := scale_to_real0.scaled_real;
  scale_to_real1(raw_input_value := flow_set_in, real_max := flow_max, real_min := flow_min);
  flow_set_real := scale_to_real1.scaled_real;
  scale_to_real2(raw_input_value := curr_pos, real_max := pos_max, real_min := pos_min);
  curr_pos_real := scale_to_real2.scaled_real;
  _TMP_SUB58_OUT := SUB(curr_pos_real, pos_update_real);
  _TMP_LIMIT40_OUT := LIMIT(pos_min, _TMP_SUB58_OUT, pos_max);
  scale_to_uint0(real_in := _TMP_LIMIT40_OUT);
  new_pos := scale_to_uint0.uint_out;
END_FUNCTION_BLOCK

FUNCTION_BLOCK composition_control
  VAR
    PID0 : PID;
    a_in_purge_real : REAL := 47.00;
  END_VAR
  VAR_INPUT
    a_in_purge : UINT := 32000;
  END_VAR
  VAR
    a_setpoint_real : REAL := 47.00;
  END_VAR
  VAR_INPUT
    a_setpoint : UINT := 32000;
    curr_pos : UINT := 16000;
  END_VAR
  VAR
    valve_pos_real : REAL := 25.0;
    pos_update_real : REAL := 0.0;
    valve_pos_nominal : REAL := 25.0;
  END_VAR
  VAR_OUTPUT
    new_pos : UINT := 16000;
  END_VAR
  VAR
    composition_k : REAL := 2.0;
    composition_ti : REAL := 99.0;
    cycle_time : TIME := T#200ms;
    scale_to_real3 : scale_to_real;
    scale_to_real2 : scale_to_real;
    scale_to_uint0 : scale_to_uint;
    comp_max : REAL := 100.0;
    comp_min : REAL := 0.0;
    pos_max : REAL := 100.0;
    pos_min : REAL := 0.0;
    scale_to_real0 : scale_to_real;
    _TMP_SUB42_OUT : REAL;
    _TMP_LIMIT44_OUT : REAL;
  END_VAR

  PID0(AUTO := TRUE, PV := a_in_purge_real, SP := a_setpoint_real, X0 := valve_pos_nominal, KP := composition_k, TR := composition_ti, CYCLE := cycle_time);
  pos_update_real := PID0.XOUT;
  scale_to_real3(raw_input_value := a_in_purge, real_max := comp_max, real_min := comp_min);
  a_in_purge_real := scale_to_real3.scaled_real;
  scale_to_real2(raw_input_value := a_setpoint, real_max := comp_max, real_min := comp_min);
  a_setpoint_real := scale_to_real2.scaled_real;
  _TMP_SUB42_OUT := SUB(valve_pos_real, pos_update_real);
  _TMP_LIMIT44_OUT := LIMIT(pos_min, _TMP_SUB42_OUT, pos_max);
  scale_to_uint0(real_in := _TMP_LIMIT44_OUT);
  new_pos := scale_to_uint0.uint_out;
  scale_to_real0(raw_input_value := curr_pos, real_max := pos_max, real_min := pos_min);
  valve_pos_real := scale_to_real0.scaled_real;
END_FUNCTION_BLOCK

FUNCTION_BLOCK pressure_override
  VAR
    pressure_real : REAL := 2700.0;
  END_VAR
  VAR_INPUT
    pressure : UINT := 58981;
    curr_sp : UINT := 58981;
  END_VAR
  VAR
    curr_sp_real : REAL := 2700.0;
    product_sp_real : REAL := 100.0;
    sp_update : REAL := 0.0;
    product_sp_nominl : REAL := 100.0;
  END_VAR
  VAR_OUTPUT
    product_sp : UINT := 13107;
  END_VAR
  VAR
    override_sp_real : REAL := 2900.0;
  END_VAR
  VAR_INPUT
    override_sp : UINT := 63350;
  END_VAR
  VAR
    override_k : REAL := 2.0;
    override_ti : REAL := 99999.0;
    cycle_time : TIME := T#200ms;
    PID0 : PID;
    scale_to_real7 : scale_to_real;
    pressure_max : REAL := 3000.0;
    pressure_min : REAL := 0.0;
    flow_max : REAL := 500.0;
    flow_min : REAL := 0.0;
    scale_to_real0 : scale_to_real;
    _TMP_MAX84_OUT : REAL;
    _TMP_SUB85_OUT : REAL;
    _TMP_LIMIT67_OUT : REAL;
    _TMP_DIV73_OUT : REAL;
    _TMP_MUL75_OUT : REAL;
    _TMP_REAL_TO_UINT79_OUT : UINT;
  END_VAR

  PID0(AUTO := TRUE, PV := pressure_real, SP := override_sp_real, KP := override_k, TR := override_ti, CYCLE := cycle_time);
  _TMP_MAX84_OUT := MAX(PID0.XOUT, 0.0);
  sp_update := _TMP_MAX84_OUT;
  scale_to_real7(raw_input_value := pressure, real_max := pressure_max, real_min := pressure_min);
  pressure_real := scale_to_real7.scaled_real;
  scale_to_real0(raw_input_value := curr_sp, real_max := flow_max, real_min := flow_min);
  curr_sp_real := scale_to_real0.scaled_real;
  _TMP_SUB85_OUT := SUB(curr_sp_real, sp_update);
  _TMP_LIMIT67_OUT := LIMIT(50.0, _TMP_SUB85_OUT, 150.0);
  product_sp_real := _TMP_LIMIT67_OUT;
  _TMP_DIV73_OUT := DIV(product_sp_real, 500.0);
  _TMP_MUL75_OUT := MUL(_TMP_DIV73_OUT, 65535.0);
  _TMP_REAL_TO_UINT79_OUT := REAL_TO_UINT(_TMP_MUL75_OUT);
  product_sp := _TMP_REAL_TO_UINT79_OUT;
END_FUNCTION_BLOCK

FUNCTION_BLOCK level_control
  VAR_INPUT
    liquid_level : UINT;
    level_sp : UINT := 30000;
    curr_pos : UINT;
  END_VAR
  VAR_OUTPUT
    new_pos : UINT;
  END_VAR
  VAR
    PID0 : PID;
    cycle_time : TIME := T#200ms;
    level_k : REAL := 2.0;
    level_ti : REAL := 99999.0;
    scale_to_real0 : scale_to_real;
    level_max : REAL := 100.0;
    level_min : REAL := 0.0;
    pos_max : REAL := 100.0;
    pos_min : REAL := 0.0;
    level_real : REAL := 44.18;
    pos_real : REAL := 47.0;
    pos_update_real : REAL := 0.0;
    sp_real : REAL := 44.18;
    scale_to_real1 : scale_to_real;
    scale_to_real2 : scale_to_real;
    scale_to_uint0 : scale_to_uint;
    _TMP_ADD30_OUT : REAL;
    _TMP_LIMIT25_OUT : REAL;
  END_VAR

  scale_to_real0(raw_input_value := liquid_level, real_max := level_max, real_min := level_min);
  level_real := scale_to_real0.scaled_real;
  scale_to_real1(raw_input_value := curr_pos, real_max := pos_max, real_min := pos_min);
  pos_real := scale_to_real1.scaled_real;
  scale_to_real2(raw_input_value := level_sp, real_max := level_max, real_min := level_min);
  sp_real := scale_to_real2.scaled_real;
  PID0(AUTO := TRUE, PV := level_real, SP := sp_real, KP := level_k, TR := level_ti, CYCLE := cycle_time);
  pos_update_real := PID0.XOUT;
  _TMP_ADD30_OUT := ADD(pos_real, pos_update_real);
  _TMP_LIMIT25_OUT := LIMIT(pos_min, _TMP_ADD30_OUT, pos_max);
  scale_to_uint0(real_in := _TMP_LIMIT25_OUT);
  new_pos := scale_to_uint0.uint_out;
END_FUNCTION_BLOCK


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    VAR_GLOBAL
      run_bit AT %QX0.0 : BOOL := 1;
    END_VAR
    TASK MainTask(INTERVAL := T#200ms,PRIORITY := 0);
    PROGRAM instance0 WITH MainTask : main;
  END_RESOURCE
END_CONFIGURATION
