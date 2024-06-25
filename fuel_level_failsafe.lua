local MAV_SEVERITY = {EMERGENCY=0, ALERT=1, CRITICAL=2, ERROR=3, WARNING=4, NOTICE=5, INFO=6, DEBUG=7}
local FLIGHT_MODE = {MANUAL=0, AUTO=10, RTL=11, QSTABILIZE=17, QLAND=20, QRTL=21}

local fuel_is_enough = true

function update()
    local current_mode = vehicle:get_mode()
    local fuel_threshold = 30
    local fuel_val = battery:capacity_remaining_pct(2) -- fuel level sensor in batt3 (instance 2)

    -- FUEL LEVEL
    if fuel_is_enough then
        if fuel_val < fuel_threshold then
            gcs:send_text(MAV_SEVERITY.INFO, "-----")
            gcs:send_text(MAV_SEVERITY.INFO, "Low Fuel Failsafe, switch to RTL soon")
            gcs:send_text(MAV_SEVERITY.WARNING, string.format("Fuel %s", fuel_val))
            gcs:send_text(MAV_SEVERITY.INFO, "-----")
            notify:play_tune("MFT240L8 O3C O2B O3C O2B")
            -- switch to RTL after t seconds under fuel_threshold
            -- vehicle:set_mode(FLIGHT_MODE.RTL)
            fuel_is_enough = false
        end
    end

    return update, 1000
end

return update, 1000