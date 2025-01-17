module OrigenARMDebug
  # This is a dummy DUT model which is used
  # to instantiate and test the ARMDebug locally
  # during development.
  #
  # It is not included when this library is imported.
  class DUT
    include Origen::TopLevel
    include OrigenARMDebug

    # Initializes simple dut model with test register and required jtag/swd pins
    #
    # @example
    #   $dut = OrigenARMDebug::DUT.new
    #
    def initialize
      add_reg :dap,  0x0, 35, data: { pos: 0, bits: 35 }

      add_reg :test, 0x0, 32, data: { pos: 0, bits: 32 },
                              bit:  { pos: 0 }

      sub_block :arm_debug, class_name: 'OrigenARMDebug::Driver', aps: { mem_ap: 0x00000000, mdm_ap: 0x01000000 }
      arm_debug.add_mem_ap('alt_ahbapi', 0x02000000)

      # arm_debug.add_mem_ap('mem_ap', 0x00000000)
      # arm_debug.add_mem_ap('mdm_ap', 0x01000000)
      # arm_debug.add_mem_ap('alt_ahbapi', 0x02000000)
    end

    # Add any custom startup business here.
    #
    # @param [Hash] options Options to customize the operation
    def startup(options)
      $tester.set_timeset('arm_debug', 40)
    end

    # Read data from a register
    #
    # @param [Register] reg Register name or address value
    # @param [Hash] options Options to customize the operation
    def read_register(reg, options = {})
      arm_debug.read_register(reg, options)
    end

    # Write data to a register
    #
    # @param [Register] reg Register name or address value
    # @param [Hash] options Options to customize the operation
    def write_register(reg, options = {})
      arm_debug.write_register(reg, options)
    end
  end
end
