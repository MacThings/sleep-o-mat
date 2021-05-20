//
//  ViewController.swift
//  Sleep-o-Mat
//
//  Created by Prof. Dr. Luigi on 19.05.21.
//

import Cocoa

class MainWindow: NSViewController {
    
    let scriptPath = Bundle.main.path(forResource: "/script/script", ofType: "command")!
    
    @IBOutlet weak var selected_system_sleep_path: NSTextField!
    @IBOutlet weak var selected_system_wakeup_path: NSTextField!
    @IBOutlet weak var selected_display_dim_path: NSTextField!
    @IBOutlet weak var selected_display_undim_path: NSTextField!
    @IBOutlet weak var selected_display_sleep_path: NSTextField!
    
    @IBOutlet weak var selected_display_wakeup_path: NSTextField!
    @IBOutlet weak var selected_user_idle_path: NSTextField!
    @IBOutlet weak var selected_user_resume_path: NSTextField!
    @IBOutlet weak var selected_power_plug_path: NSTextField!
    @IBOutlet weak var selected_power_unplug_path: NSTextField!
    
    
    @IBOutlet weak var run_button: NSButton!
    @IBOutlet weak var sw_running_dot: NSImageView!
    @IBOutlet weak var dm_running_dot: NSImageView!
    
    
    
    @IBOutlet weak var install_daemon: NSButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height);

        run_check()

        init_check()
        
        let alert_check = UserDefaults.standard.bool(forKey: "AlertShown")
        if alert_check == false {
            let alert = NSAlert()
            alert.messageText = NSLocalizedString("Important!", comment: "")
            alert.informativeText = NSLocalizedString("If you make changes please make sure to press the Start/Stop button (if sleepwatcher is running in daemon mode press Reload) to take the changes affect.", comment: "")
            alert.alertStyle = .warning
            alert.icon = NSImage(named: "applied")
            let Button = NSLocalizedString("I understand", comment: "")
            alert.addButton(withTitle: Button)
            alert.runModal()
            UserDefaults.standard.set(true, forKey: "AlertShown")
            return
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func init_check() {
        let system_sleep_path = UserDefaults.standard.string(forKey: "system_sleep_path")
        if system_sleep_path != nil{
            let splitter = system_sleep_path!.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
            let lastElement = splitter.last
            selected_system_sleep_path.stringValue = lastElement!
        }
        let system_wakeup_path = UserDefaults.standard.string(forKey: "system_wakeup_path")
        if system_wakeup_path != nil{
            let splitter = system_wakeup_path!.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
            let lastElement = splitter.last
            selected_system_wakeup_path.stringValue = lastElement!
        }
        let display_dim_path = UserDefaults.standard.string(forKey: "display_dim_path")
        if display_dim_path != nil{
            let splitter = display_dim_path!.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
            let lastElement = splitter.last
            selected_display_dim_path.stringValue = lastElement!
        }
        let display_undim_path = UserDefaults.standard.string(forKey: "display_undim_path")
        if display_undim_path != nil{
            let splitter = display_undim_path!.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
            let lastElement = splitter.last
            selected_display_undim_path.stringValue = lastElement!
        }
        let display_sleep_path = UserDefaults.standard.string(forKey: "display_sleep_path")
        if display_sleep_path != nil{
            let splitter = display_sleep_path!.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
            let lastElement = splitter.last
            selected_display_sleep_path.stringValue = lastElement!
        }
        let display_wakeup_path = UserDefaults.standard.string(forKey: "display_wakeup_path")
        if display_wakeup_path != nil{
            let splitter = display_wakeup_path!.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
            let lastElement = splitter.last
            selected_display_wakeup_path.stringValue = lastElement!
        }
        let user_idle_path = UserDefaults.standard.string(forKey: "user_idle_path")
        if user_idle_path != nil{
            let splitter = user_idle_path!.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
            let lastElement = splitter.last
            selected_user_idle_path.stringValue = lastElement!
        }
        let user_resume_path = UserDefaults.standard.string(forKey: "user_resume_path")
        if user_resume_path != nil{
            let splitter = user_resume_path!.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
            let lastElement = splitter.last
            selected_user_resume_path.stringValue = lastElement!
        }
        let power_plug_path = UserDefaults.standard.string(forKey: "power_plug_path")
        if power_plug_path != nil{
            let splitter = power_plug_path!.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
            let lastElement = splitter.last
            selected_power_plug_path.stringValue = lastElement!
        }
        let power_unplug_path = UserDefaults.standard.string(forKey: "power_unplug_path")
        if power_unplug_path != nil{
            let splitter = power_unplug_path!.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
            let lastElement = splitter.last
            selected_power_unplug_path.stringValue = lastElement!
        }
        let alert_init = UserDefaults.standard.string(forKey: "alert_check")
        if alert_init != nil{
            UserDefaults.standard.set(false, forKey: "AlertShown")
        }
    }
    
    func run_check() {
        syncShellExec(path: scriptPath, args: ["run_check"])
        let sw_running = UserDefaults.standard.bool(forKey: "sleepwatcher_running")
        if sw_running == true{
            self.sw_running_dot.image=NSImage(named: "NSStatusAvailable")
            self.run_button.title = NSLocalizedString("Stop", comment: "")
        } else {
            self.sw_running_dot.image=NSImage(named: "NSStatusUnavailable")
            self.run_button.title = NSLocalizedString("Run", comment: "")
        }
        
        let dm_running = UserDefaults.standard.bool(forKey: "daemon_running")
        if dm_running == true{
            self.install_daemon.title = NSLocalizedString("Uninstall", comment: "")
            self.dm_running_dot.image=NSImage(named: "NSStatusAvailable")
            self.run_button.title = NSLocalizedString("Reload", comment: "")
        } else {
            self.install_daemon.title = NSLocalizedString("Install", comment: "")
            self.dm_running_dot.image=NSImage(named: "NSStatusUnavailable")
        }
    }
    
    @IBAction func install_daemon(_ sender: Any) {
        syncShellExec(path: scriptPath, args: ["kill_sw"])
        let dm_running = UserDefaults.standard.bool(forKey: "daemon_running")
        if dm_running == true{
            syncShellExec(path: scriptPath, args: ["uninstall_daemon"])
            run_check()
        } else {
            syncShellExec(path: scriptPath, args: ["install_daemon"])
            run_check()
        }
    }
    
    @IBAction func start_stop_sw(_ sender: Any) {
        run_check()
        let dm_running = UserDefaults.standard.bool(forKey: "daemon_running")
        if dm_running != true{
            let sw_running = UserDefaults.standard.bool(forKey: "sleepwatcher_running")
            if sw_running == true{
                syncShellExec(path: scriptPath, args: ["kill_sw"])
            } else {
                syncShellExec(path: scriptPath, args: ["start_sw"])
            }
        } else {
            syncShellExec(path: scriptPath, args: ["reload_daemon"])
        }
        run_check()
    }
    
    @IBAction func template_system_sleep(_ sender: Any) {
        syncShellExec(path: scriptPath, args: ["template_system_sleep"])
        let template = UserDefaults.standard.string(forKey: "system_sleep_path")
        if template != nil{
            let splitter = template!.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
            let lastElement = splitter.last
            selected_system_sleep_path.stringValue = lastElement!
        }
    }
    

    @IBAction func browseFile_system_sleep(sender: AnyObject) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a Folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        //dialog.allowedFileTypes        = ["sh"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                let splitter = path.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
                let lastElement = splitter.last
                selected_system_sleep_path.stringValue = lastElement!
                let savepath = (path as String)
                UserDefaults.standard.set(savepath, forKey: "system_sleep_path")
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    @IBAction func browseFile_system_wakeup(sender: AnyObject) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a Folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        //dialog.allowedFileTypes        = ["sh"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                let splitter = path.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
                let lastElement = splitter.last
                selected_system_wakeup_path.stringValue = lastElement!
                let savepath = (path as String)
                UserDefaults.standard.set(savepath, forKey: "system_wakeup_path")
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
 
    @IBAction func browseFile_display_dim(sender: AnyObject) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a Folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        //dialog.allowedFileTypes        = ["sh"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                let splitter = path.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
                let lastElement = splitter.last
                selected_display_dim_path.stringValue = lastElement!
                let savepath = (path as String)
                UserDefaults.standard.set(savepath, forKey: "display_dim_path")
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }

    @IBAction func browseFile_display_undim(sender: AnyObject) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a Folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        //dialog.allowedFileTypes        = ["sh"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                let splitter = path.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
                let lastElement = splitter.last
                selected_display_undim_path.stringValue = lastElement!
                let savepath = (path as String)
                UserDefaults.standard.set(savepath, forKey: "display_undim_path")
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }

    @IBAction func browseFile_display_sleep(sender: AnyObject) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a Folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        //dialog.allowedFileTypes        = ["sh"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                let splitter = path.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
                let lastElement = splitter.last
                selected_display_sleep_path.stringValue = lastElement!
                let savepath = (path as String)
                UserDefaults.standard.set(savepath, forKey: "display_sleep_path")
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }

    @IBAction func browseFile_display_wakeup(sender: AnyObject) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a Folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        //dialog.allowedFileTypes        = ["sh"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                let splitter = path.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
                let lastElement = splitter.last
                selected_display_wakeup_path.stringValue = lastElement!
                let savepath = (path as String)
                UserDefaults.standard.set(savepath, forKey: "display_wakeup_path")
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    @IBAction func browseFile_user_idle(sender: AnyObject) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a Folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        //dialog.allowedFileTypes        = ["sh"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                let splitter = path.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
                let lastElement = splitter.last
                selected_user_idle_path.stringValue = lastElement!
                let savepath = (path as String)
                UserDefaults.standard.set(savepath, forKey: "user_idle_path")
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }

    @IBAction func browseFile_user_resume(sender: AnyObject) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a Folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        //dialog.allowedFileTypes        = ["sh"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                let splitter = path.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
                let lastElement = splitter.last
                selected_user_resume_path.stringValue = lastElement!
                let savepath = (path as String)
                UserDefaults.standard.set(savepath, forKey: "user_resume_path")
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
 
    @IBAction func browseFile_power_plug(sender: AnyObject) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a Folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        //dialog.allowedFileTypes        = ["sh"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                let splitter = path.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
                let lastElement = splitter.last
                selected_power_plug_path.stringValue = lastElement!
                let savepath = (path as String)
                UserDefaults.standard.set(savepath, forKey: "power_plug_path")
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
 
    @IBAction func browseFile_power_unplug(sender: AnyObject) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a Folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        //dialog.allowedFileTypes        = ["sh"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                let splitter = path.components(separatedBy: "/") //Gibt den letzten Wert des Arrays aus
                let lastElement = splitter.last
                selected_power_unplug_path.stringValue = lastElement!
                let savepath = (path as String)
                UserDefaults.standard.set(savepath, forKey: "power_unplug_path")
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    func syncShellExec(path: String, args: [String] = []) {
        let process            = Process()
        process.launchPath     = "/bin/bash"
        process.arguments      = [path] + args
        process.launch()
        process.waitUntilExit()
    }
    

}

