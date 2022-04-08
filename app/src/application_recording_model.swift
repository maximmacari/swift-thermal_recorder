/**
 * \file    application_recording_model.swift
 * \author  Mauricio Villarroel
 * \date    Created: Apr 1, 2022
 * ____________________________________________________________________________
 *
 * Copyright (C) 2022 Mauricio Villarroel. All rights reserved.
 *
 * SPDX-License-Identifer:  GPL-2.0-only
 * ____________________________________________________________________________
 */

import Foundation
import UIKit
import Combine
import SensorRecordingUtils
import ThermalCamera


/**
 * The main class that will manage the entire recording process. It will
 * controll the capture tasks for all the devices we are configuring
 */
@MainActor
final class Application_recording_model : Recording_session_model
{
    
    /**
     * Class initialiser
     */
    init(
            participant_id        : String ,
            interface_orientation : UIDeviceOrientation = .portrait,
            preview_mode          : Device.Content_mode = .scale_to_fill,
            thermal_manager       : ThermalCamera.Recording_manager? = nil
        )
    {
                
        super.init(
            participant_id            : participant_id ,
            interface_orientation     : interface_orientation,
            preview_mode              : preview_mode
        )
        
        
        if let manager = thermal_manager
        {
            add_camera(manager)
        }
        
    }
    
    
    // MARK: - Private state
    
    
    private let settings = Application_settings()
    
    
    // MARK: - Private interface to handle adding/removing devices
    
    
    /**
     * Add all configured devices to the recording set
     */
    override func add_all_configured_devices()
    {
        
        add_camera(
            ThermalCamera.Recording_manager(
                orientation       : interface_orientation,
                preview_mode      : preview_mode,
                device_state      : .disconnected,
                connection_timeout: Double(settings.connection_timeout)
            )
        )
        
    }
    
}
