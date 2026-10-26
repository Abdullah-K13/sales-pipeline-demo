

def test_this_one_fails_on_purpose():
    df = add_total(frame([[1, "2026-10-18", "Karachi", "Leash", 3, 500]]))
    assert df.loc[0, "total"] == 9999      # it is really 1500
