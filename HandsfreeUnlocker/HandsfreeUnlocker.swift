//
//  HandsfreeUnlocker.swift
//  HandsfreeUnlocker
//
//  Created by 山本敬太 on 2020/10/12.
//

import Foundation
import CoreBluetooth
import UIKit

class HandsfreeUnlocker: NSObject {

    static var shared = HandsfreeUnlocker()

    let smartLockBLEServiceIDs = [CBUUID(string: "FD81")]
    let managerKey = "HandsfreeUnlocker"

    private var centralManager: CBCentralManager?
    var peripherals: [CBPeripheral] = []
    var waitingConnectDevices: [CBPeripheral] = []

    func prepare() {
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey: managerKey])
    }
}

extension HandsfreeUnlocker: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager?.scanForPeripherals(withServices: smartLockBLEServiceIDs, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            LocalNotification.shared.notify(title: "Discover", text: "didDiscover a new device. name=\(peripheral.name ?? "")")
            peripherals.append(peripheral)
            centralManager?.connect(peripheral, options: nil)
        }

        if waitingConnectDevices.contains(peripheral) {
            LocalNotification.shared.notify(title: "Discover", text: "didDiscover a waiting device. name=\(peripheral.name ?? "")")
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if waitingConnectDevices.contains(peripheral) {
            LocalNotification.shared.notify(title: "Connect", text: "didConnect to a waiting device. name=\(peripheral.name ?? "")")
            waitingConnectDevices.removeAll{ $0.identifier == peripheral.identifier }

            // NOTE: Unlock the smart lock device here
        }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        LocalNotification.shared.notify(title: "Disconnect", text: "didDisconnect to a device. name=\(peripheral.name ?? "")")
        waitingConnectDevices.append(peripheral)
        centralManager?.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
    }
}

