/**
 * \file    participant_model.swift
 * \author  Mauricio Villarroel
 * \date    Created: Apr 1, 2022
 * ____________________________________________________________________________
 *
 * Copyright (C) 2022 Mauricio Villarroel. All rights reserved.
 *
 * SPDX-License-Identifer:  GPL-2.0-only
 * ____________________________________________________________________________
 */

import SwiftUI
import Combine
import ThermalCamera
import SensorRecordingUtils


@MainActor
final class Participant_model: Participant_entry_model
{
    
    override init()
    {
        
        super.init()
        
        load_settings_bundle()
        load_last_particpant_id()
        
    }
    
    
    deinit
    {
        
        Task
        {
            [weak self] in
            
            await self?.deinit_thermal_camera_watchdog()
        }
        
    }
    
    
    // MARK: - Public interface to responde system events
    
    
    
    override func register_for_system_events()
    {
        
        super.register_for_system_events()
        
        if settings.search_thermal_camera_on_app_start
        {
            start_thermal_camera_watchdog()
        }
        
    }
    
    
    override func cancel_system_event_subscriptions()
    {
        
        super.cancel_system_event_subscriptions()
        stop_thermal_camera_watchdog()
        
    }
    
    
    // MARK: - Public interface
    
    
    /**
     * Verify all the information required is valid before start recoding
     * data
     */
    override func is_configuration_valid() async -> Bool
    {
                
        if await super.is_configuration_valid() == false
        {
            return false
        }

        
        // Check system state
        
        
        guard let camera = thermal_camera_monitor  ,
              camera.is_connected
            else
            {
                setup_error = .no_thermal_camera_access
                return false
            }

        
        cancel_system_event_subscriptions()
        deinit_thermal_camera_watchdog()
        
        return true
        
    }
    
    
    // MARK: - Private state
    
    
    private let settings = Application_settings()
    
    private var thermal_camera_monitor : Thermal_camera_state_monitor? = nil
    
    private var thermal_camera_event_subscriptions = Set<AnyCancellable>()
    
    
    // MARK: - Utility methods for the Thermal camera state changes
    
    
    private func start_thermal_camera_watchdog()
    {
        
        if thermal_camera_monitor == nil
        {
            thermal_camera_monitor = Thermal_camera_state_monitor()
        }
        
        
        if thermal_camera_event_subscriptions.isEmpty
        {
            
            thermal_camera_monitor?.$device_state_message.receive(on: RunLoop.main)
                .sink
                {
                    [weak self] value in
                    
                    self?.system_message = value
                }
                .store(in: &thermal_camera_event_subscriptions)
            
            
            thermal_camera_monitor?.$battery_percentage.receive(on: RunLoop.main)
                .sink
                {
                    [weak self] value in
                    
                    self?.new_thermal_battery_percentage(value)
                }
                .store(in: &thermal_camera_event_subscriptions)
            
            
            thermal_camera_monitor?.$battery_state.receive(on: RunLoop.main)
                .sink
                {
                    [weak self] value in
                    
                    self?.new_thermal_battery_state(value)
                }
                .store(in: &thermal_camera_event_subscriptions)
            
        }
        
        thermal_camera_monitor?.start()
        
    }
    
    
    public func stop_thermal_camera_watchdog()
    {
        print("stop_thermal_camera_watchdog : ")
        
        thermal_camera_monitor?.stop()
        
        for subscription in thermal_camera_event_subscriptions
        {
            subscription.cancel()
        }
        
        thermal_camera_event_subscriptions.removeAll()
        
        new_thermal_battery_state(nil)
        new_thermal_battery_percentage(nil)
        system_message = nil
        
    }
    
    
    public func deinit_thermal_camera_watchdog()
    {
        
        stop_thermal_camera_watchdog()
        thermal_camera_monitor = nil
        
    }
    
    
    private func new_thermal_battery_percentage(
            _ percentage : Battery_percentage?
        )
    {
        
        system_message = nil
        
        if let new_percentage = percentage ,
           let index = all_battery_percentages.firstIndex(of: new_percentage)
        {
            all_battery_percentages[index].value = new_percentage.value
        }
        else if let new_percentage = percentage
        {
            all_battery_percentages.append(new_percentage)
        }
        else
        {
            all_battery_percentages.removeAll{ $0.id != system_identifier }
        }
        
    }
    
    
    private func new_thermal_battery_state( _ state : Battery_state? )
    {
        
        system_message = nil
        
        if let new_state = state ,
           let index = all_battery_states.firstIndex(of: new_state)
        {
            all_battery_states[index].value = new_state.value
        }
        else if let new_state = state
        {
            all_battery_states.append(new_state)
        }
        else
        {
            all_battery_states.removeAll{ $0.id != system_identifier }
        }
        
    }
    
}
