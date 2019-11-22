import UIKit

extension UIScreen {

    public func animateBrightness(to newValue: CGFloat, duration: TimeInterval, ticksPerSecond: Double = 60) {
        let startingBrightness = UIScreen.main.brightness
        let delta = newValue - startingBrightness
        let totalTicks = Int(ticksPerSecond * duration)
        let changePerTick = delta / CGFloat(totalTicks)
        let delayBetweenTicks = 1 / ticksPerSecond

        brightness += changePerTick

        DispatchQueue.global(qos: .userInteractive).async {
            var previousValue = self.brightness

            for _ in 2...totalTicks {
                Thread.sleep(forTimeInterval: delayBetweenTicks)

                guard previousValue == self.brightness else {
                    // Value has changed since thread went to sleep 😴
                    return
                }
                let nextValue = min(1, self.brightness + changePerTick)

                self.brightness = nextValue

                // Don't use `nextValue` here as iOS appears to do some rounding, so
                // the actual value of `self.brightness` may differ from `nextValue`
                previousValue = self.brightness
            }
        }
    }

}
