--[[
this is a Dzvent script !

with this script will be enable the simultaneus controll from a master blind to slves blinds


{ "slaves" : [ "tap1_esp32", "tap2_esp32", "tap3_esp32", "tap4_esp32" ] }


]]--

return
{
    on =
    {
        devices =
        {
           'tapALL_esp8266_ip57', 'tapALL_esp32_ip56',--'tasmotaBlind*', -- add here all master blind device name. Note that All blinds with name starting with 'tasmotaBlind' if you use wild card *
        },
    },

    logging =
    {
        level = domoticz.LOG_DEBUG,
        marker = tasmota_MASTER_Blind,
    },

    execute = function(dz, item)

        local function masterBlind(description)
            for _, slave in ipairs(description.slaves) do -- Loop over all slave devices
                slaveDevice = dz.devices(slave)
                slaveDescription = dz.utils.fromJSON(slaveDevice.description)
                dz.log(slaveDescription, dz.LOG_DEBUG)

                -- Slave devices to follow master
                if item.state == 'Closed' then
                    slaveDevice.close().silent()
                elseif item.state == 'Open' then
                    slaveDevice.open().silent()
                else
                    slaveDevice.dimTo(item.level).silent()
                end

                
            end
        end

        -- Main
        local description = dz.utils.fromJSON(item.description)
        if item.description:lower():find('slaves') then -- Master oppure se si vuole usare la wildcard "master" nel nome usare:  if item.name:lower():find('master') then 
            masterBlind(description)
        end
    end
}