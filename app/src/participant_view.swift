/**
 * \file    participant_view.swift
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
import SensorRecordingUtils


/**
 * The first view the app shows to the user.
 */
struct Participant_view: View
{
    
    var body: some View
    {
        
        Participant_entry_view(
                model: model,
                interface_orientation : $interface_orientation
            )
            {
                Application_recording_view(
                        participant_id        : model.participant_id,
                        interface_orientation : interface_orientation,
                        preview_mode          : .scale_to_fill
                    )
            }
            action_buttons:
            {
            }
            .hide_navigation_interface()
        
    }
    
    
    init()
    {
        
        self._model = StateObject( wrappedValue: Participant_model() )

    }
    
    
    // MARK: - Private state
    
    
    @StateObject private var model : Participant_model
        
    @State private var interface_orientation = UIDeviceOrientation.unknown
    
    
}



struct Participant_view_Previews: PreviewProvider
{
    
    
    static var previews: some View
    {
        NavigationView
        {
            Participant_view()
        }
        .navigationViewStyle(.stack)
        .previewInterfaceOrientation(.portrait)

    }
    
}
