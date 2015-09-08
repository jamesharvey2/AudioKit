//
//  AKLowPassButterworthFilter.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka on 9/8/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** A low-pass Butterworth filter.

These filters are Butterworth second-order IIR filters. They offer an almost flat passband and very good precision and stopband attenuation.
*/
@objc class AKLowPassButterworthFilter : AKParameter {

    // MARK: - Properties

    private var butlp = UnsafeMutablePointer<sp_butlp>.alloc(1)
    private var input = AKParameter()


    /** Cutoff frequency. [Default Value: 1000] */
    var cutoffFrequency: AKParameter = akp(1000) {
        didSet { cutoffFrequency.bind(&butlp.memory.freq) }
    }


    // MARK: - Initializers

    /** Instantiates the filter with default values */
    init(input source: AKParameter)

    {
        super.init()
        input = source
        setup()
        bindAll()
    }

    /**
    Instantiates the filter with all values

    :param: input Input audio signal. 
    :param: cutoffFrequency Cutoff frequency. [Default Value: 1000]
    */
    convenience init(
        input           source: AKParameter,
        cutoffFrequency freq:   AKParameter)
    {
        self.init(input: source)

        cutoffFrequency = freq

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal filter */
    internal func bindAll() {
        cutoffFrequency.bind(&butlp.memory.freq)
    }

    /** Internal set up function */
    internal func setup() {
        sp_butlp_create(&butlp)
        sp_butlp_init(AKManager.sharedManager.data, butlp)
    }

    /** Computation of the next value */
    override func compute() -> Float {
        sp_butlp_compute(AKManager.sharedManager.data, butlp, &(input.value), &value);
        pointer.memory = value
        return value
    }

    /** Release of memory */
    override func teardown() {
        sp_butlp_destroy(&butlp)
    }
}
