defmodule IndiParserTest do
  use ExUnit.Case

  test "parsing def switch vector" do
    xml = """
    <defSwitchVector device="CCD Simulator" name="CONNECTION" label="Connection" group="Main Control" state="Idle" perm="rw" rule="OneOfMany" timeout="60" timestamp="2023-01-19T14:47:12">
      <defSwitch name="CONNECT" label="Connect">
    Off
      </defSwitch>
      <defSwitch name="DISCONNECT" label="Disconnect">
    On
      </defSwitch>
    </defSwitchVector>
    """

    expected = {:ok, %{
      "CCD Simulator" => %{
        "CONNECTION" => %{
          "defSwitch" => %{
            "CONNECT" => %{
              "label" => "Connect",
              "name" => "CONNECT",
              "value" => "Off"
            },
            "DISCONNECT" => %{
              "label" => "Disconnect",
              "name" => "DISCONNECT",
              "value" => "On"
            }
          },
          "device" => "CCD Simulator",
          "group" => "Main Control",
          "label" => "Connection",
          "name" => "CONNECTION",
          "perm" => "rw",
          "rule" => "OneOfMany",
          "state" => "Idle",
          "timeout" => "60",
          "timestamp" => "2023-01-19T14:47:12"
        }
      }
    }}

    assert IndiClient.Protocol.Parser.parse(xml, %{}) == expected
  end

  test "parsing def switch vector with initial state" do
    xml = """
    <defSwitchVector device="CCD Simulator" name="CONNECTION" label="Connection" group="Main Control" state="Idle" perm="rw" rule="OneOfMany" timeout="60" timestamp="2023-01-19T14:47:12">
      <defSwitch name="CONNECT" label="Connect">
    On
      </defSwitch>
      <defSwitch name="DISCONNECT" label="Disconnect">
    Off
      </defSwitch>
    </defSwitchVector>
    """

    expected = {:ok, %{
      "CCD Simulator" => %{
        "CONNECTION" => %{
          "defSwitch" => %{
            "CONNECT" => %{
              "label" => "Connect",
              "name" => "CONNECT",
              "value" => "On"
            },
            "DISCONNECT" => %{
              "label" => "Disconnect",
              "name" => "DISCONNECT",
              "value" => "Off"
            }
          },
          "device" => "CCD Simulator",
          "group" => "Main Control",
          "label" => "Connection",
          "name" => "CONNECTION",
          "perm" => "rw",
          "rule" => "OneOfMany",
          "state" => "Idle",
          "timeout" => "60",
          "timestamp" => "2023-01-19T14:47:12"
        }
      }
    }}

    assert IndiClient.Protocol.Parser.parse(xml, %{
      "CCD Simulator" => %{
        "CONNECTION" => %{
          "defSwitch" => %{
            "CONNECT" => %{
              "label" => "Connect",
              "name" => "CONNECT",
              "value" => "Off"
            },
            "DISCONNECT" => %{
              "label" => "Disconnect",
              "name" => "DISCONNECT",
              "value" => "On"
            }
          },
          "device" => "CCD Simulator",
          "group" => "Main Control",
          "label" => "Connection",
          "name" => "CONNECTION",
          "perm" => "rw",
          "rule" => "OneOfMany",
          "state" => "Idle",
          "timeout" => "60",
          "timestamp" => "2023-01-19T14:47:12"
        }
      }
    }
    ) == expected
  end

  test "parsing def text vector" do
    xml = """
    <defTextVector device="CCD Simulator" name="DRIVER_INFO" label="Driver Info" group="General Info" state="Idle" perm="ro" timeout="60" timestamp="2023-01-19T14:47:12">
        <defText name="DRIVER_NAME" label="Name">
    CCD Simulator
        </defText>
        <defText name="DRIVER_EXEC" label="Exec">
    indi_simulator_ccd
        </defText>
        <defText name="DRIVER_VERSION" label="Version">
    1.0
        </defText>
        <defText name="DRIVER_INTERFACE" label="Interface">
    22
        </defText>
    </defTextVector>
    """

    expected = {:ok, %{
      "CCD Simulator" => %{
        "DRIVER_INFO" => %{
          "defText" => %{
            "DRIVER_NAME" => %{
              "label" => "Name",
              "name" => "DRIVER_NAME",
              "value" => "CCD Simulator"
            },
            "DRIVER_EXEC" => %{
              "label" => "Exec",
              "name" => "DRIVER_EXEC",
              "value" => "indi_simulator_ccd"
            },
            "DRIVER_VERSION" => %{
              "label" => "Version",
              "name" => "DRIVER_VERSION",
              "value" => "1.0"
            },
            "DRIVER_INTERFACE" => %{
              "label" => "Interface",
              "name" => "DRIVER_INTERFACE",
              "value" => "22"
            }
          },
          "device" => "CCD Simulator",
          "name" => "DRIVER_INFO",
          "label" => "Driver Info",
          "group" => "General Info",
          "state" => "Idle",
          "perm" => "ro",
          "timeout" => "60",
          "timestamp" => "2023-01-19T14:47:12"
        }
      }
    }}

    assert IndiClient.Protocol.Parser.parse(xml, %{}) == expected
  end

  test "parsing def number vector" do
    xml = """
    <defNumberVector device="CCD Simulator" name="CCD_TEMPERATURE" label="Temperature" group="Main Control" state="Idle" perm="rw" timeout="60" timestamp="2023-01-19T14:47:43">
        <defNumber name="CCD_TEMPERATURE_VALUE" label="Temperature (C)" format="%5.2f" min="-50" max="50" step="0">
    0
        </defNumber>
    </defNumberVector>
    """

    expected = {:ok, %{
      "CCD Simulator" => %{
        "CCD_TEMPERATURE" => %{
          "defNumber" => %{
            "CCD_TEMPERATURE_VALUE" => %{
              "label" => "Temperature (C)",
              "name" => "CCD_TEMPERATURE_VALUE",
              "format" => "%5.2f",
              "min" => "-50",
              "max" => "50",
              "step" => "0",
              "value" => "0"
            }
          },
          "device" => "CCD Simulator",
          "name" => "CCD_TEMPERATURE",
          "label" => "Temperature",
          "group" => "Main Control",
          "state" => "Idle",
          "perm" => "rw",
          "timeout" => "60",
          "timestamp" => "2023-01-19T14:47:43"
        }
      }
    }}

    assert IndiClient.Protocol.Parser.parse(xml, %{}) == expected
  end

  test "parsing set number vector" do
    xml = """
    <setNumberVector device="CCD Simulator" name="CCD_TEMPERATURE" state="Busy" timeout="60" timestamp="2023-01-19T14:48:35">
        <oneNumber name="CCD_TEMPERATURE_VALUE">
    -17.5
        </oneNumber>
    </setNumberVector>
    """

    expected = {:ok, %{
      "CCD Simulator" => %{
        "CCD_TEMPERATURE" => %{
          "defNumber" => %{
            "CCD_TEMPERATURE_VALUE" => %{
              "label" => "Temperature (C)",
              "name" => "CCD_TEMPERATURE_VALUE",
              "format" => "%5.2f",
              "min" => "-50",
              "max" => "50",
              "step" => "0",
              "value" => "-17.5"
            }
          },
          "device" => "CCD Simulator",
          "name" => "CCD_TEMPERATURE",
          "label" => "Temperature",
          "group" => "Main Control",
          "state" => "Busy",
          "perm" => "rw",
          "timeout" => "60",
          "timestamp" => "2023-01-19T14:48:35"
        }
      }
    }}

    assert IndiClient.Protocol.Parser.parse(xml, %{
      "CCD Simulator" => %{
        "CCD_TEMPERATURE" => %{
          "defNumber" => %{
            "CCD_TEMPERATURE_VALUE" => %{
              "label" => "Temperature (C)",
              "name" => "CCD_TEMPERATURE_VALUE",
              "format" => "%5.2f",
              "min" => "-50",
              "max" => "50",
              "step" => "0",
              "value" => "0"
            }
          },
          "device" => "CCD Simulator",
          "name" => "CCD_TEMPERATURE",
          "label" => "Temperature",
          "group" => "Main Control",
          "state" => "Idle",
          "perm" => "rw",
          "timeout" => "60",
          "timestamp" => "2023-01-19T14:47:43"
        }
      }
    }) == expected
  end

  test "parsing set switch vector" do
    xml = """
    <setSwitchVector device="CCD Simulator" name="CONNECTION" state="Ok" timeout="60" timestamp="2023-01-19T14:47:43">
        <oneSwitch name="CONNECT">
    On
        </oneSwitch>
        <oneSwitch name="DISCONNECT">
    Off
        </oneSwitch>
    </setSwitchVector>
    """

    expected = {:ok, %{
      "CCD Simulator" => %{
        "CONNECTION" => %{
          "defSwitch" => %{
            "CONNECT" => %{
              "label" => "Connect",
              "name" => "CONNECT",
              "value" => "On"
            },
            "DISCONNECT" => %{
              "label" => "Disconnect",
              "name" => "DISCONNECT",
              "value" => "Off"
            }
          },
          "device" => "CCD Simulator",
          "group" => "Main Control",
          "label" => "Connection",
          "name" => "CONNECTION",
          "perm" => "rw",
          "rule" => "OneOfMany",
          "state" => "Ok",
          "timeout" => "60",
          "timestamp" => "2023-01-19T14:47:43"
        }
      }
    }}

    assert IndiClient.Protocol.Parser.parse(xml, %{
      "CCD Simulator" => %{
        "CONNECTION" => %{
          "defSwitch" => %{
            "CONNECT" => %{
              "label" => "Connect",
              "name" => "CONNECT",
              "value" => "Off"
            },
            "DISCONNECT" => %{
              "label" => "Disconnect",
              "name" => "DISCONNECT",
              "value" => "On"
            }
          },
          "device" => "CCD Simulator",
          "group" => "Main Control",
          "label" => "Connection",
          "name" => "CONNECTION",
          "perm" => "rw",
          "rule" => "OneOfMany",
          "state" => "Idle",
          "timeout" => "60",
          "timestamp" => "2023-01-19T14:47:12"
        }
      }
    }) == expected
  end

  test "parsing partial" do
    xml = [
      "<setSwitchVector device=\"CCD Simulator\" name=\"CONNECTION\" state=\"Ok\" timeout=\"60\" timestamp=\"2023-01-19T14:47:43\">",
      "<oneSwitch name=\"CONNECT\">",
      "On",
      "</oneSwitch>",
      "<oneSwitch name=\"DISCONNECT\">",
      "Off",
      "</oneSwitch>",
      "</setSwitchVector>"
    ]

    expected = {:ok, %{
      "CCD Simulator" => %{
        "CONNECTION" => %{
          "defSwitch" => %{
            "CONNECT" => %{
              "label" => "Connect",
              "name" => "CONNECT",
              "value" => "On"
            },
            "DISCONNECT" => %{
              "label" => "Disconnect",
              "name" => "DISCONNECT",
              "value" => "Off"
            }
          },
          "device" => "CCD Simulator",
          "group" => "Main Control",
          "label" => "Connection",
          "name" => "CONNECTION",
          "perm" => "rw",
          "rule" => "OneOfMany",
          "state" => "Ok",
          "timeout" => "60",
          "timestamp" => "2023-01-19T14:47:43"
        }
      }
    }}

    {:ok, partial} = Saxy.Partial.new(IndiClient.Protocol.SaxEventHandler, %{
      "CCD Simulator" => %{
        "CONNECTION" => %{
          "defSwitch" => %{
            "CONNECT" => %{
              "label" => "Connect",
              "name" => "CONNECT",
              "value" => "Off"
            },
            "DISCONNECT" => %{
              "label" => "Disconnect",
              "name" => "DISCONNECT",
              "value" => "On"
            }
          },
          "device" => "CCD Simulator",
          "group" => "Main Control",
          "label" => "Connection",
          "name" => "CONNECTION",
          "perm" => "rw",
          "rule" => "OneOfMany",
          "state" => "Idle",
          "timeout" => "60",
          "timestamp" => "2023-01-19T14:47:12"
        }
      }
    })

    state = Enum.reduce_while(xml, partial, fn line, partial ->
      {:cont, partial} = Saxy.Partial.parse(partial, line)
      case partial do
        %{state: %{stack: [], prolog: []}} -> {:halt, Saxy.Partial.terminate(partial)}
        _ -> {:cont, partial}
      end
    end)

    assert state == expected
  end
end
