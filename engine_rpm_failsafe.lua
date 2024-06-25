local MAV_SEVERITY = {EMERGENCY=0, ALERT=1, CRITICAL=2, ERROR=3, WARNING=4, NOTICE=5, INFO=6, DEBUG=7}
local FLIGHT_MODE = {MANUAL=0, AUTO=10, RTL=11, QSTABILIZE=17, QLAND=20, QRTL=21}
local ENGINE_IS_ON = true
local RPM_INSTANCE = 0 -- rpm1 correlates to instance 0 (lists start at 0)

function update()
    local current_mode = vehicle:get_mode()
    local rpm_val = RPM:get_rpm(RPM_INSTANCE) 

    -- ENGINE RPM
    if ENGINE_IS_ON == true then
        if current_mode == FLIGHT_MODE.QSTABILIZE then -- and armed_state == true
            if rpm_val == nil then
                gcs:send_text(MAV_SEVERITY.INFO, "-----")
                gcs:send_text(MAV_SEVERITY.INFO, "0 RPM Failsafe, switch to QRTL now")
                gcs:send_text(MAV_SEVERITY.WARNING, "RPM 0")
                gcs:send_text(MAV_SEVERITY.INFO, "-----")
                notify:play_tune("MFT240L20 O2GO3CEA#O4D# O2G#O3C#FBO4E")
                -- switch to QRTL when rpm goes to zero
                -- vehicle:set_mode(FLIGHT_MODE.QRTL)
                ENGINE_IS_ON = false
            end
        end
    end

    return update, 1000
end

return update()