---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Acer.
--- DateTime: 2021/7/28 11:28
---

--- Plugins Info ---
script_name('God_Of_Car')
script_authors('Weidu')
script_version('2.0.0')
script_description('QQ: 487432640')
--- Plugins Info ---


local event = require("lib.samp.events") --- @type Events 依赖samp事件库
local inicfg = require("inicfg") --- @type Config 依赖ini配置文件库
local file_config = 'moonloader/config/GodOfCarConfig.ini'
local config_path = 'GodOfCarConfig.ini'
local GodOfCarCfg = {
    速度设置 = {
        发射载具速度 = 66.66,
    },
    范围设置 = {
        获取载具范围半径 = 10000,
        获取玩家范围半径 = 10000,
    },
}


local switch_shoot = false --- @type boolean 发射载具
local switch_rip = false --- @type boolean 悄无声息
local switch_smash = false --- @type boolean 误封
local unoccupied_sync = false --- @type boolean 同步未占用
local nop_unoccupied_sync = false --- @type boolean 取消同步未占用

local tid = 0 --- @type number 定义目标对象

local switch_aim = false --- @type boolean 定义准星
aim = nil

local file_name = 'moonloader/God_Of_Car.lua'
local file_lib = 'moonloader/lib/samp'
local file_resource = 'moonloader/resource/Weidu'


--- @class Main
function main()
    repeat wait(0) until isSampAvailable() wait(3000)
    --- 生成配置文件
    GodOfCarCfg = inicfg.load(GodOfCarCfg, config_path)
    inicfg.save(GodOfCarCfg, config_path)
    --- 1. 检测Events库
    if not doesDirectoryExist(file_lib) then
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {F70202}检测到你没有samp事件库，插件停止运行！', -1)
        script:pause(file_name)
    else
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {2FD184}依赖库没有缺失...', -1)
    end
    --- 2. 检测资源文件夹
    if not doesDirectoryExist(file_resource) then --- 判断 @file_resource 目录
        createDirectory(file_resource) --- 自动创建该目录
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {F70202}检测到资源文件中没有"Weidu"文件夹，自动为您生成！', -1)
    else
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {2FD184}资源文件正常...', -1)
    end
    --- 3. 检测插件名称
    if doesFileExist(file_name) then
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {2FD184}插件名称正常...', -1)
    else
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {F70202}请将插件名称复原！', -1)
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {F70202}请将插件名称复原！', -1)
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {F70202}请将插件名称复原！', -1)
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {F70202}请将插件名称复原！', -1)
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {F70202}请将插件名称复原！', -1)
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {F70202}请将插件名称复原！', -1)
        script:pause(file_name)
    end
    --- 定义准星贴图
    aim = renderLoadTextureFromFile("moonloader/resource/Weidu/aim.png")
    renderBegin(aim)
    renderColor(1)
    renderEnd()
    --- 注册指令
    sampRegisterChatCommand("goc.help", goc_help) --- 查看帮助
    sampRegisterChatCommand("goc.load", goc_load) --- 加载配置文件
    sampRegisterChatCommand("goc.s", goc_shoot) --- 发射载具
    sampRegisterChatCommand("goc.r", goc_rip) --- 悄无声息
    sampRegisterChatCommand("goc.z", goc_smash) --- 砸人
    sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {2FD184}加载成功 ver: 2.0.0', -1)
    sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {2FD184}请尊重作者的成果！', -1)
    sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {2FD184}By Weidu QQ:487432640', -1)
    while true do wait(0)
        ---=== 钩子 ===---
        nop_unoccupied_sync = unoccupied_sync
        if unoccupied_sync then
            local x, y, z = getCharCoordinates(PLAYER_PED)
            local _, veh = findAllRandomVehiclesInSphere(x, y, z, GodOfCarCfg.范围设置.获取载具范围半径, true, true)
            if _ then
                local _, vid = sampGetVehicleIdByCarHandle(veh)
                if _ then
                    wait(0)
                    pcall(sampForceUnoccupiedSyncSeatId, vid, 65535) --- 强制同步未占用 65535 = nil
                end
            end
        end
        ---=== 准星钩子 ===---
        if not sampIsChatInputActive() and switch_shoot and isKeyDown(0x02) then --- 右键
            switch_aim = true
        else
            switch_aim = false
        end
        if switch_aim then
            lua_thread.create(Aim_Draw, 0.05) ---创建线程
        end
    end
end


--- @class goc_help 查看帮助
function goc_help()
    sampAddChatMessage('                        {FF1203}===========================================', -1)
    sampAddChatMessage('                                                 {F61D00}[{00F8FA}God_Of_Car By Weidu{F61D00}]', -1)
    sampAddChatMessage('          {F98C00}更新配置文件: {F50505}/goc.load {F0F703} 说明: 在moonloader/config/GodOfCarConfig.ini', -1)
    sampAddChatMessage('          {F98C00}发射载具: {F50505}/goc.s{F0F703} 说明: 按右键发射范围内的载具，确保载具当中无人！', -1)
    sampAddChatMessage('          {F98C00}悄无声息: {F50505}/goc.r{F0F703} 说明: 按住R键对范围内的玩家顶上天，确保范围内有载具，并且当中无人！', -1)
    sampAddChatMessage('          {F98C00}砸人: {F50505}/goc.z{F0F703} 说明: 指定一名玩家，会被空车砸！', -1)
    sampAddChatMessage('                                                       {F61D00}[{00F8FA}QQ: 487432640{F61D00}]', -1)
    sampAddChatMessage('                        {FF1203}===========================================', -1)
end

--- @class goc_load 更新配置文件
function goc_load()
    if doesFileExist(file_config) then
        GodOfCarCfg = inicfg.load(GodOfCarCfg, config_path)
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {2FD184}配置文件更新完成！', -1)
    else
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {2FD184}没有找到配置文件，请重新进入游戏，自动生成配置文件。', -1)
    end
end

--- @class goc_shoot 发射载具
function goc_shoot()
    if switch_shoot then
        switch_shoot = false
        unoccupied_sync = false
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {F70202}关闭！', -1)
    else
        switch_shoot = true
        unoccupied_sync = true
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {05FB00}发射载具开启！按住右键发射！', -1)
    end
end

--- @class goc_rip 悄无声息
function goc_rip()
    if switch_rip then
        switch_rip = false
        unoccupied_sync = false
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {F70202}关闭！', -1)
    else
        switch_rip = true
        unoccupied_sync = true
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {05FB00}悄无声息开启成功！请刷出载具然后下车或者有空闲车的附近按R键！', -1)
    end
end

--- @class goc_smash 砸人
function goc_smash(args)
    if switch_smash then
        switch_smash = false
        unoccupied_sync = false
        return sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {F70202}关闭！', -1)
    end
    tid = args:match('%d+')
    if not tid then
        sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {0EEFBD}请输入/goc.z [目标ID]', -1)
    else
        local _, ped = sampGetCharHandleBySampPlayerId(args)
        if not _ then
            sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {2FD184}指定的{E5E31B}目标{2FD184}不在范围内！', -1)
        else
            tid = tonumber(args)
            switch_smash = true
            unoccupied_sync = true
            lua_thread.create(function() --- 创建线程
                sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {2FD184}开启！目标{E5E31B}[' .. tid .. ']', -1)
                while switch_smash do wait(0)
                    local _, ped = sampGetCharHandleBySampPlayerId(args)
                    if not _ then
                        switch_smash = false
                        unoccupied_sync = false
                        return sampAddChatMessage('{F61D00}[{00F8FA}God_Of_Car{F61D00}]: {F70202}停止执行，玩家离开了范围。', -1)
                    end
                end
            end)
        end
    end
end


--- @class SendUnoccupiedSync
function event.onSendUnoccupiedSync(data, id)
    if switch_shoot and switch_aim then
        
        if isKeyDown(0x02) then
            local cx, cy, cz = getActiveCameraCoordinates() --- 获取相机活动坐标
            local tx, ty, tz = getActiveCameraPointAt()  --- 获取相机指向点
            local angle = getHeadingFromVector2d(tx - cx, ty - cy)
            setCharHeading(PLAYER_PED, angle)
            local x, y, z = getCharCoordinates(PLAYER_PED)
            data.position = { x, y, z }
            data.moveSpeed.x = math.sin(-math.rad(angle)) * GodOfCarCfg.速度设置.发射载具速度
            data.moveSpeed.y = math.cos(-math.rad(angle)) * GodOfCarCfg.速度设置.发射载具速度
            data.seatId = 65535
            setCharQuaternion(PLAYER_PED, 2, 2, 4, 5)
            printStringNow('~Y~~>~[God_Of_Car]~<~', 1000)
        end return data
    end

    if switch_rip then
        local X, Y, Z = getCharCoordinates(PLAYER_PED) --- 获取坐标 PLAYER_PED = LocalPlayer
        local _, ped = findAllRandomCharsInSphere(X, Y, Z, GodOfCarCfg.范围设置.获取玩家范围半径, true, false) --- 以自身坐标为半径 获取玩家 PED = RemotePlayer
        local _, show = sampGetPlayerIdByCharHandle(ped) --- 获取半径内的玩家id
        if _ then
            if isKeyDown(0x52) then
                local tX, tY, tZ = getCharCoordinates(ped)
                local cameraCoordinates = Vector3D(getActiveCameraCoordinates()) --- 获取相机坐标
                local cameraPointAt = Vector3D(getActiveCameraPointAt()) --- 相机指向点
                local warpDirection = cameraPointAt - cameraCoordinates
                warpDirection = warpDirection * 0.1
                data.position.x = tX
                data.position.y = tY
                data.position.z = tZ - 1
                data.turnSpeed.z = tZ + 3.0
                data.moveSpeed['z'] = warpDirection:get()
                data.seatId = 65535
                printStringNow('~Y~God_Of_Car ~B~By Weidu ~R~~>~[ID: ' .. show .. ']~<~', 1000)
            end return data
        end
    end

    if switch_smash then
        local _, ped = sampGetCharHandleBySampPlayerId(tid) --- 通过参数获取受害者id
        if _ then
            local tX, tY, tZ = getCharCoordinates(ped)
            data.position.x = tX
            data.position.y = tY
            data.position.z = tZ + 8
            if data.position.z == tZ + 8 then
                data.moveSpeed.z = - 4.0
            else
                data.position.z = tZ + 8
            end
            data.seatId = 1
            printStringNow('~Y~God_Of_Car ~B~By Weidu ~R~~>~[ID: ' .. tid .. ']~<~', 1000)
        end return data
    end
end


--- @class Aim_Draw 准星数据构造
function Aim_Draw(duration)
    local w, h = getScreenResolution()
    local drawto = os.clock() + duration
    while drawto > os.clock() and aim do
        renderDrawTexture(aim, w/2-48, h/2-128, 5120, 5120, 0, 0xffffffff)
        wait(0)
    end
end

function onExitScript()
    if aim then renderReleaseTexture(aim) end
end













