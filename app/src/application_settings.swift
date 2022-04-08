/**
 * \file    application_settings.swift
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
import SensorRecordingUtils
import ThermalCamera


/**
 * Main configuration for the recording process.
 *
 * In the future, this class should be presented as the main App settings,
 * with a customised UI so the user can configure the APP
 */
final class Application_settings : Recording_settings
{
    
    
    // MARK: - Global settings
    
    
    /**
     * Search thermal camera when the application starts
     */
    var search_thermal_camera_on_app_start : Bool
    {
        get
        {
            return store.bool(forKey: search_thermal_on_app_start_key)
        }
        
        set(new_value)
        {
            store.set(new_value, forKey: search_thermal_on_app_start_key)
        }
    }
    
    
    
    /**
     * Type innitialiser
     */
    public override init()
    {
        
        let key_prefix = "app_"
        
        search_thermal_on_app_start_key = key_prefix + "search_thermal_on_app_start"
        
        super.init()
        
    }
    
    
    // MARK: - Private state
    
    
    private let search_thermal_on_app_start_key : String
    
}
