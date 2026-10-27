
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using Microsoft.Reporting.WebForms;

namespace ELibrary.Admin.Reports.Finance
{
    public partial class CustomerBalances : Page
    {
        private const string CacheKey = "ELibrary_Report_CustomerBalances";

        [Serializable]
        private sealed class ReportState
        {
            public DataTable Data { get; set; }
            public string Search { get; set; }
            public string FeeType { get; set; }
            public decimal Minimum { get; set; }
            public DateTime GeneratedAt { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                Session.Remove(CacheKey);
                pnlResults.Visible = false;
                pnlEmpty.Visible = true;
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            decimal minimum;

            if (!decimal.TryParse(
                ddlMinimum.SelectedValue,
                NumberStyles.Number,
                CultureInfo.InvariantCulture,
                out minimum) || minimum <= 0)
            {
                Reset("Please select a valid minimum balance.");
                return;
            }

            string search = (txtSearch.Text ?? "").Trim();
            string feeType = ddlFeeType.SelectedValue;

            if (search.Length > 150)
            {
                Reset("Search cannot exceed 150 characters.");
                return;
            }

            try
            {
                ReportState state = new ReportState
                {
                    Search = search,
                    FeeType = feeType,
                    Minimum = minimum,
                    GeneratedAt = DateTime.Now,
                    Data = LoadData(search, feeType, minimum)
                };

                Session[CacheKey] = state;
                BindReport(state);
            }
            catch (Exception)
            {
                Reset("Unable to generate customer balances. Check the SQL procedure and RDLC.");
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            if (AdminHelper.IsAdmin(Session) &&
                IsPostBack &&
                string.IsNullOrEmpty(lblError.Text))
            {
                ReportState state = Session[CacheKey] as ReportState;

                if (state != null)
                {
                    try
                    {
                        BindReport(state);
                    }
                    catch (Exception)
                    {
                        Reset("Unable to display the outstanding balance report.");
                    }
                }
            }

            base.OnPreRender(e);
        }

        private DataTable LoadData(
            string search, string feeType, decimal minimum)
        {
            DataTable table = new DataTable("CustomerBalancesDataSet");

            string cs = ConfigurationManager
                .ConnectionStrings["ElibraryConnection"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(
                "dbo.EReport_CustomerBalances", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 60;

                cmd.Parameters.Add("@Search", SqlDbType.NVarChar, 150).Value =
                    string.IsNullOrWhiteSpace(search)
                        ? (object)DBNull.Value : search;

                cmd.Parameters.Add("@FeeType", SqlDbType.VarChar, 50).Value =
                    string.IsNullOrEmpty(feeType)
                        ? (object)DBNull.Value : feeType;

                SqlParameter minimumParameter =
                    cmd.Parameters.Add("@MinimumBalance",
                        SqlDbType.Decimal);
                minimumParameter.Precision = 10;
                minimumParameter.Scale = 2;
                minimumParameter.Value = minimum;

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(table);
                }
            }

            return table;
        }

        private void BindReport(ReportState state)
        {
            if (state.Data.Rows.Count == 0)
            {
                pnlResults.Visible = false;
                pnlEmpty.Visible = true;
                lblError.Text = "No outstanding receipts match the filters.";
                return;
            }

            decimal outstanding = 0m;

            foreach (DataRow row in state.Data.Rows)
            {
                outstanding += Convert.ToDecimal(
                    row["OutstandingBalance"]);
            }

            string total = Money(outstanding);

            lblReceipts.Text = state.Data.Rows.Count.ToString("N0");
            lblOutstanding.Text = total;

            pnlResults.Visible = true;
            pnlEmpty.Visible = false;

            rvReport.ProcessingMode = ProcessingMode.Local;
            rvReport.LocalReport.ReportPath = Server.MapPath(
                "~/Reports/Finance/CustomerBalances.rdlc");

            rvReport.LocalReport.DataSources.Clear();

            rvReport.LocalReport.DataSources.Add(
                new ReportDataSource(
                    "CustomerBalancesDataSet", state.Data));

            rvReport.LocalReport.SetParameters(
                new ReportParameter[]
                {
                    new ReportParameter("GeneratedOn",
                        state.GeneratedAt.ToString(
                            "MMM dd, yyyy hh:mm tt")),
                    new ReportParameter("Filters",
                        "Search: " +
                        (string.IsNullOrEmpty(state.Search)
                            ? "All" : state.Search) +
                        " | Fee: " +
                        (string.IsNullOrEmpty(state.FeeType)
                            ? "All" : state.FeeType) +
                        " | Minimum: " + Money(state.Minimum)),
                    new ReportParameter("TotalOutstanding", total)
                });

            rvReport.LocalReport.Refresh();
            lblError.Text = "";
        }

        private static string Money(decimal amount)
        {
            return "₱" + amount.ToString("N2",
                CultureInfo.GetCultureInfo("en-PH"));
        }

        private void Reset(string message)
        {
            Session.Remove(CacheKey);
            pnlResults.Visible = false;
            pnlEmpty.Visible = true;
            lblError.Text = Server.HtmlEncode(message);
        }
    }
}
